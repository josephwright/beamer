# Changelog
All notable changes to this project since v3.50 will be documented in this
file.

The format is based on [Keep a
Changelog](https://keepachangelog.com/en/1.0.0/), version strings comprise
a major and minor version only.

## [Unreleased]

## [v3.51]

### Changed
- Add `\include` and `\input` to commands respected in 'skipping' mode
- Dynamically calculate note page size (see #487)

### Fixed
- Properly set space in rounded boxes
- Enable transparency in shadows (see #466)
- Restore `\secname` in `\sectionentry`
- Apply color correctly to page number (see #468)
- Support for `noxcolor` with `beamerarticle` (see #483)
- Treatment of mixed overlay/alert specifications

[Unreleased]: https://github.com/josephwright/beamer/compare/v3.51...HEAD
[v3.51]: https://github.com/josephwright/beamer/compare/v3.50...v3.51
