
## Changelog gatherer

The `releaser` script is used to create a GitHub release, including:
- update the `versions-config.json` file
- update the `CHANGELOG.md` file
- create a GitHub release itself

It gathers commits between specified tags across the repositories specified in `changelog_config.json`, matches them
with pull requests and formats their titles into a list of changes.

For a pull request to be included in the changelog, add a `changelog` label to it.

Other labels can be used to control which section the changes end up in and the component that will be mentioned.

Each pull request can be assigned to a single section – if more than one section (type) label is assigned
to a pull request, then the one that is above in the changelog-config will be chosen. A pull request can be assigned
to any number of components, they will appear in a changelog record in the order in which they are specified
in the changelog-config.

Use the following labels to assign a pull request to a section:
- `type/breaking-change` -> Breaking changes
- `type/new-feature` -> New features
- `type/bug-fix` -> Bug fixes
- `type/sec` -> Security
- `type/deprecation` -> Deprecation
- `type/dev` -> Development
- `type/tests` -> Tests
- `type/CI` -> CI
- `type/chore` -> Chores

Use the following labels to assign a pull request to a component,
which will put its name in front of the pull request title:
- `component/charts` -> Charts
- `component/connectors` -> Connectors
- `component/navigation` -> Navigation
- `component/general` -> General components
- `component/dashboards` -> Dashboards
- `component/datasets` -> Datasets
- `component/auth` -> Auth
- `component/optimization` -> Optimization
- `component/role-model` -> Role model
- `component/docs` -> Docs
- `component/formula` -> Formula

This manual is generated from a config file, `changelog_config.json`, which includes all possible labels and their role,
known repositories and texts.
