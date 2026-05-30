package cli

import "github.com/charmbracelet/lipgloss"

type Theme struct {
	foreground string
	muted      string
	blue       string
	cyan       string
	green      string
	yellow     string
	red        string
	purple     string
}

func (t Theme) Foreground() lipgloss.Color {
	return lipgloss.Color(t.foreground)
}

func (t Theme) Muted() lipgloss.Color {
	return lipgloss.Color(t.muted)
}

func (t Theme) Blue() lipgloss.Color {
	return lipgloss.Color(t.blue)
}

func (t Theme) Cyan() lipgloss.Color {
	return lipgloss.Color(t.cyan)
}

func (t Theme) Green() lipgloss.Color {
	return lipgloss.Color(t.green)
}

func (t Theme) Yellow() lipgloss.Color {
	return lipgloss.Color(t.yellow)
}

func (t Theme) Red() lipgloss.Color {
	return lipgloss.Color(t.red)
}

func (t Theme) Purple() lipgloss.Color {
	return lipgloss.Color(t.purple)
}

func NewTheme(f, m, b, c, g, y, r, p string) Theme {
	return Theme{
		foreground: f,
		muted:      m,
		blue:       b,
		cyan:       c,
		green:      g,
		yellow:     y,
		red:        r,
		purple:     p,
	}
}

// Iceberg palette, based on cocopon/iceberg.vim.
var iceberg = NewTheme(
	"#c6c8d1",
	"#6b7089",
	"#84a0c6",
	"#89b8c2",
	"#b4be82",
	"#e2a478",
	"#e27878",
	"#a093c7",
)

var (
	titleStyle   = newStyle().Bold(true).Foreground(iceberg.Blue())
	sectionStyle = newStyle().Bold(true).Foreground(iceberg.Purple())
	successStyle = newStyle().Foreground(iceberg.Green())
	warningStyle = newStyle().Foreground(iceberg.Yellow())
	errorStyle   = newStyle().Foreground(iceberg.Red())
	mutedStyle   = newStyle().Foreground(iceberg.Muted())
	bulletStyle  = newStyle().Foreground(iceberg.Cyan())
	bodyStyle    = newStyle().Foreground(iceberg.Foreground())
)

func newStyle() lipgloss.Style {
	return lipgloss.NewStyle()
}

func Title(s string) string {
	return titleStyle.Render(s)
}

func Section(s string) string {
	return sectionStyle.Render(s)
}

func Success(s string) string {
	return successStyle.Render(s)
}

func Warning(s string) string {
	return warningStyle.Render(s)
}

func Error(s string) string {
	return errorStyle.Render(s)
}

func Muted(s string) string {
	return mutedStyle.Render(s)
}

func Body(s string) string {
	return bodyStyle.Render(s)
}

func Bullet() string {
	return bulletStyle.Render("•")
}
