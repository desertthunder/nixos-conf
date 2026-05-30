window.siteShell = function () {
  return {
    navOpen: false,
    searchQuery: '',
    searchResults: [],
    searchLoading: false,
    searchError: '',
    searchReady: false,
    _searchToken: 0,
    get searchActive() {
      return this.searchQuery.trim().length > 0;
    },
    async runSearch() {
      const query = this.searchQuery.trim();
      const token = ++this._searchToken;

      if (!query) {
        this.searchResults = [];
        this.searchLoading = false;
        this.searchError = '';
        return;
      }

      this.searchLoading = true;
      this.searchError = '';

      try {
        const pagefind = await import('/pagefind/pagefind.js');
        if (!this.searchReady && pagefind.options) {
          await pagefind.options({ highlightParam: 'highlight' });
          this.searchReady = true;
        }
        const response = await pagefind.search(query);
        const results = await Promise.all(response.results.slice(0, 12).map((result) => result.data()));
        if (token !== this._searchToken) return;
        this.searchResults = results;
      } catch (error) {
        if (token !== this._searchToken) return;
        this.searchResults = [];
        this.searchError = 'Search index is not built yet. Run the Pagefind step after building the site.';
      } finally {
        if (token === this._searchToken) this.searchLoading = false;
      }
    },
    clearSearch() {
      this.searchQuery = '';
      this.searchResults = [];
      this.searchLoading = false;
      this.searchError = '';
      this._searchToken++;
    },
  };
};
