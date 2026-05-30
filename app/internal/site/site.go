package site

import (
	"bytes"
	"errors"
	"fmt"
	"html/template"
	"io"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"sort"
	"strings"
	"time"

	"github.com/yuin/goldmark"
	"github.com/yuin/goldmark/extension"
	"github.com/yuin/goldmark/parser"
	"github.com/yuin/goldmark/renderer/html"
	"gopkg.in/yaml.v3"
)

type Config struct {
	Root    string
	Content string
	Layouts string
	Assets  string
	Output  string
}

type Page struct {
	Title       string `yaml:"title"`
	Description string `yaml:"description"`
	Section     string `yaml:"section"`
	Status      string `yaml:"status"`
	Weight      int    `yaml:"weight"`
	SourcePath  string
	OutputPath  string
	URL         string
	Content     template.HTML
}

type NavSection struct {
	Title      string
	URL        string
	Pages      []Page
	IsCurrent  bool
	HasDefault bool
}

type TemplateData struct {
	SiteTitle string
	Page      Page
	Pages     []Page
	Sections  []NavSection
	BuiltAt   time.Time
}

func DefaultConfig(root string) Config {
	return Config{
		Root:    root,
		Content: filepath.Join(root, "site", "content"),
		Layouts: filepath.Join(root, "site", "layouts"),
		Assets:  filepath.Join(root, "site", "assets"),
		Output:  filepath.Join(root, "dist"),
	}
}

func Build(cfg Config) error {
	pages, err := LoadPages(cfg)
	if err != nil {
		return err
	}
	if len(pages) == 0 {
		return fmt.Errorf("no markdown pages found in %s", cfg.Content)
	}

	if err := os.RemoveAll(cfg.Output); err != nil {
		return err
	}
	if err := os.MkdirAll(cfg.Output, 0o755); err != nil {
		return err
	}
	if err := copyDir(cfg.Assets, filepath.Join(cfg.Output, "assets")); err != nil {
		return err
	}

	tmpl, err := loadTemplates(cfg.Layouts)
	if err != nil {
		return err
	}

	for _, page := range pages {
		out := filepath.Join(cfg.Output, page.OutputPath)
		if err := os.MkdirAll(filepath.Dir(out), 0o755); err != nil {
			return err
		}
		file, err := os.Create(out)
		if err != nil {
			return err
		}
		data := TemplateData{SiteTitle: "Desert Thunder's Dotfiles", Page: page, Pages: pages, Sections: buildNavSections(pages, page), BuiltAt: time.Now()}
		err = tmpl.ExecuteTemplate(file, "base.html", data)
		closeErr := file.Close()
		if err != nil {
			return err
		}
		if closeErr != nil {
			return closeErr
		}
	}

	return nil
}

func Clean(cfg Config) error {
	return os.RemoveAll(cfg.Output)
}

func Check(cfg Config) error {
	pages, err := LoadPages(cfg)
	if err != nil {
		return err
	}
	if len(pages) == 0 {
		return fmt.Errorf("no markdown pages found in %s", cfg.Content)
	}
	for _, page := range pages {
		if strings.TrimSpace(page.Title) == "" {
			return fmt.Errorf("missing title: %s", page.SourcePath)
		}
	}
	return nil
}

func Serve(cfg Config, addr string) error {
	if _, err := os.Stat(cfg.Output); errors.Is(err, os.ErrNotExist) {
		if err := Build(cfg); err != nil {
			return err
		}
	}
	return serveDir(cfg.Output, addr)
}

func Preview(cfg Config, addr string) error {
	if err := Build(cfg); err != nil {
		return err
	}
	if err := Pagefind(cfg); err != nil {
		fmt.Fprintf(os.Stderr, "pagefind unavailable: %v\n", err)
	}
	url := "http://localhost" + addr
	if err := openBrowser(url); err != nil {
		fmt.Fprintf(os.Stderr, "could not open browser: %v\n", err)
		fmt.Fprintf(os.Stderr, "open %s manually\n", url)
	}
	return serveDir(cfg.Output, addr)
}

func serveDir(dir, addr string) error {
	fmt.Printf("serving %s at http://localhost%s\n", dir, addr)
	server := &http.Server{Addr: addr, Handler: http.FileServer(http.Dir(dir))}
	return server.ListenAndServe()
}

func Pagefind(cfg Config) error {
	if _, err := exec.LookPath("pagefind"); err != nil {
		return fmt.Errorf("pagefind is not installed; install it and retry")
	}
	if _, err := os.Stat(cfg.Output); errors.Is(err, os.ErrNotExist) {
		if err := Build(cfg); err != nil {
			return err
		}
	}
	cmd := exec.Command("pagefind", "--site", cfg.Output)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	return cmd.Run()
}

func openBrowser(url string) error {
	var cmd *exec.Cmd
	switch runtime.GOOS {
	case "darwin":
		cmd = exec.Command("open", url)
	case "linux":
		cmd = exec.Command("xdg-open", url)
	case "windows":
		cmd = exec.Command("rundll32", "url.dll,FileProtocolHandler", url)
	default:
		return fmt.Errorf("unsupported platform %s", runtime.GOOS)
	}
	return cmd.Start()
}

func LoadPages(cfg Config) ([]Page, error) {
	md := goldmark.New(
		goldmark.WithExtensions(extension.GFM),
		goldmark.WithParserOptions(parser.WithAutoHeadingID()),
		goldmark.WithRendererOptions(html.WithUnsafe()),
	)

	var pages []Page
	if err := filepath.WalkDir(cfg.Content, func(path string, entry os.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if entry.IsDir() || filepath.Ext(path) != ".md" {
			return nil
		}

		page, err := loadPage(cfg, md, path)
		if err != nil {
			return err
		}
		pages = append(pages, page)
		return nil
	}); err != nil {
		return nil, err
	}

	sort.Slice(pages, func(i, j int) bool {
		if pages[i].Weight != pages[j].Weight {
			return pages[i].Weight < pages[j].Weight
		}
		return pages[i].URL < pages[j].URL
	})
	return pages, nil
}

func buildNavSections(pages []Page, current Page) []NavSection {
	sectionIndexes := map[string]int{}
	sections := make([]NavSection, 0)

	for _, page := range pages {
		title := strings.TrimSpace(page.Section)
		if title == "" {
			title = "Other"
		}

		idx, ok := sectionIndexes[title]
		if !ok {
			sectionIndexes[title] = len(sections)
			sections = append(sections, NavSection{Title: title})
			idx = len(sections) - 1
		}

		section := &sections[idx]
		section.Pages = append(section.Pages, page)
		if page.URL == current.URL {
			section.IsCurrent = true
		}

		trimmedURL := strings.Trim(page.URL, "/")
		if strings.Count(trimmedURL, "/") == 1 && strings.HasSuffix(trimmedURL, "/overview") {
			section.URL = page.URL
			section.HasDefault = true
		}
	}

	for i := range sections {
		if !sections[i].HasDefault && len(sections[i].Pages) == 1 {
			sections[i].URL = sections[i].Pages[0].URL
			sections[i].HasDefault = true
		}
	}

	return sections
}

func loadPage(cfg Config, md goldmark.Markdown, path string) (Page, error) {
	raw, err := os.ReadFile(path)
	if err != nil {
		return Page{}, err
	}

	front, body := splitFrontMatter(raw)
	page := Page{SourcePath: path}
	if len(front) > 0 {
		if err := yaml.Unmarshal(front, &page); err != nil {
			return Page{}, fmt.Errorf("front matter %s: %w", path, err)
		}
	}

	var rendered bytes.Buffer
	if err := md.Convert(body, &rendered); err != nil {
		return Page{}, err
	}

	rel, err := filepath.Rel(cfg.Content, path)
	if err != nil {
		return Page{}, err
	}
	urlPath := strings.TrimSuffix(filepath.ToSlash(rel), ".md")
	if strings.HasSuffix(urlPath, "/index") {
		urlPath = strings.TrimSuffix(urlPath, "index")
	}
	if urlPath == "index" {
		urlPath = ""
	}

	page.URL = "/" + strings.Trim(urlPath, "/") + "/"
	if page.URL == "//" {
		page.URL = "/"
	}
	page.OutputPath = filepath.Join(strings.Trim(page.URL, "/"), "index.html")
	if page.OutputPath == "index.html" || page.OutputPath == "." {
		page.OutputPath = "index.html"
	}
	if page.Title == "" {
		page.Title = titleFromPath(path)
	}
	if page.Section == "" {
		parts := strings.Split(strings.Trim(urlPath, "/"), "/")
		if len(parts) > 1 {
			page.Section = parts[0]
		}
	}
	page.Content = template.HTML(rendered.String())
	return page, nil
}

func splitFrontMatter(raw []byte) ([]byte, []byte) {
	if !bytes.HasPrefix(raw, []byte("---\n")) {
		return nil, raw
	}
	rest := raw[len("---\n"):]
	idx := bytes.Index(rest, []byte("\n---\n"))
	if idx < 0 {
		return nil, raw
	}
	return rest[:idx], rest[idx+len("\n---\n"):]
}

func loadTemplates(layouts string) (*template.Template, error) {
	funcs := template.FuncMap{
		"active": func(current, candidate string) string {
			if current == candidate {
				return "is-active"
			}
			return ""
		},
	}
	tmpl := template.New("site").Funcs(funcs)

	var files []string
	if err := filepath.WalkDir(layouts, func(path string, entry os.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if entry.IsDir() || filepath.Ext(path) != ".html" {
			return nil
		}
		files = append(files, path)
		return nil
	}); err != nil {
		return nil, err
	}
	if len(files) == 0 {
		return nil, fmt.Errorf("no templates found in %s", layouts)
	}
	return tmpl.ParseFiles(files...)
}

func titleFromPath(path string) string {
	base := strings.TrimSuffix(filepath.Base(path), filepath.Ext(path))
	base = strings.ReplaceAll(base, "-", " ")
	return strings.Title(base)
}

func copyDir(src, dst string) error {
	if _, err := os.Stat(src); errors.Is(err, os.ErrNotExist) {
		return nil
	}
	return filepath.WalkDir(src, func(path string, entry os.DirEntry, err error) error {
		if err != nil {
			return err
		}
		rel, err := filepath.Rel(src, path)
		if err != nil {
			return err
		}
		target := filepath.Join(dst, rel)
		if entry.IsDir() {
			return os.MkdirAll(target, 0o755)
		}
		return copyFile(path, target)
	})
}

func copyFile(src, dst string) error {
	if err := os.MkdirAll(filepath.Dir(dst), 0o755); err != nil {
		return err
	}
	in, err := os.Open(src)
	if err != nil {
		return err
	}
	defer in.Close()
	out, err := os.Create(dst)
	if err != nil {
		return err
	}
	_, err = io.Copy(out, in)
	closeErr := out.Close()
	if err != nil {
		return err
	}
	return closeErr
}
