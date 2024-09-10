
# nflverse.workflows

<!-- badges: start -->
<!-- badges: end -->

This is a nflverse internal package that is aimed to be used in GitHub actions. It's a zero dependency package for quick workflow setup where an easy way to compute current seasons or weeks is needed.

## Usage

This is a basic example where we setup a runner to install R and the nflverse.workflows package and then query a range of seasons including the most recent season. The result is being written to the output variable seasons. This variable is then available to other jobs. The next job would be multiple runs because we passed a range of seasons and it is setup as a matrix workflow. 

For a full example in production, see the [current NGS workflow](https://github.com/nflverse/ngs-data/blob/main/.github/workflows/update_ngs.yaml)

``` yaml
jobs:
  setup:
    runs-on: ubuntu-latest
    name: setup
    env:
      GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    outputs:
      seasons: ${{ steps.query_seasons.outputs.seasons }}
    steps:
      - uses: r-lib/actions/setup-r@v2

      - uses: r-lib/actions/setup-r-dependencies@v2
        with:
          packages: nflverse/nflverse-workflows

      - id: query_seasons
        name: Query Seasons
        run: |
          seasons=$( Rscript -e 'nflverse.workflows::get_season_range(2016)' )
          echo "seasons=$seasons" >> "$GITHUB_OUTPUT"
  
  next_job:
    needs: setup
    name: Update ${{ matrix.season }} ${{ matrix.type }}
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix:
        season: ${{ fromJson(needs.setup.outputs.seasons) }}
        type: ["passing", "rushing", "receiving"]
    env:
      GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      NFLVERSE_UPDATE_SEASON: ${{ matrix.season }}
      NFLVERSE_UPDATE_TYPE: ${{ matrix.type }}
```

