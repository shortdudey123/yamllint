YamlLint gem CHANGELOG
======================
This file is used to list changes made in each version of the YamlLint gem.

Unreleased
-------------------

v0.0.9 (2016-09-16)
-------------------
- **[PR #24](https://github.com/shortdudey123/yamllint/pull/24)** - Update RSpec raise_error to be more specific
- **[PR #25](https://github.com/shortdudey123/yamllint/pull/25)** - Fix bug with files_to_exclude puts in Rake Task
- **[PR #26](https://github.com/shortdudey123/yamllint/pull/26)** - Clean up Rubocop cop settings

v0.0.8 (2016-07-10)
-------------------
- **[PR #13](https://github.com/shortdudey123/yamllint/pull/13)** - Update Ruby syntax per Rubocop v0.37.0
- **[PR #15](https://github.com/shortdudey123/yamllint/pull/15)** - Rake.application.last_comment has been deprecated
- **[PR #18](https://github.com/shortdudey123/yamllint/pull/18)** - Update Ruby syntax per Rubocop v0.40.0
- **[PR #17](https://github.com/shortdudey123/yamllint/pull/17)** - Expose debug logging
- **[PR #19](https://github.com/shortdudey123/yamllint/pull/19)** - Pry is a devel dependency not a runtime dependency
- **[PR #20](https://github.com/shortdudey123/yamllint/pull/20)** - Update TravisCI Ruby versions

v0.0.7 (2016-01-19)
-------------------
- **[ISSUE #10](https://github.com/shortdudey123/yamllint/issues/10)** / **[PR #12](https://github.com/shortdudey123/yamllint/pull/12)** - Add exclude path option to Raketask

v0.0.6 (2015-05-13)
-------------------
- **[ISSUE #7](https://github.com/shortdudey123/yamllint/issues/7)** - Detects dupe keys on arrays of hashes (**Proper fix**)

v0.0.5 (2015-05-05)
-------------------
- **[ISSUE #7](https://github.com/shortdudey123/yamllint/issues/7)** - Detects dupe keys on arrays of hashes

v0.0.4 (2015-02-17)
-------------------
- Clean up code by extracting out complex_type_start
- Extract out valid extensions to an array
- Allow disabling of the file extension check
- Allow custom file extensions

v0.0.3 (2015-01-15)
-------------------
- **[ISSUE #1](https://github.com/shortdudey123/yamllint/issues/1)** - Add more verbose output
- **[ISSUE #2](https://github.com/shortdudey123/yamllint/issues/2)** - Add file extension verification
- add fail_on_error option to rake task

v0.0.2 (2015-01-15)
-------------------
- Fix rake_task filename

v0.0.1 (2015-01-15)
-------------------
- Initial gem publish
