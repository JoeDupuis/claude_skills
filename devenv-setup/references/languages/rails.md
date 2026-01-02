# Rails Language Setup for Devenv

## Detection

Detect a Rails project by checking for:
- `Gemfile` containing `rails` gem, OR
- `config/application.rb` file exists

## Prerequisites

Rails setup requires Ruby to be configured first. Always perform the Ruby setup steps before proceeding with Rails-specific steps.

## Setup Steps

### 1. Complete Ruby Setup First

Follow all steps from `references/languages/ruby.md`:
- Ensure `.ruby-version` exists (create if needed)
- Copy base templates from `assets/base/`
- Apply Ruby configuration additions to `devenv.nix` and `devenv.yaml`
- Update ignore files
- Test devenv configuration with `devenv shell "echo 'Devenv setup successful'"`

### 2. Initialize Bundler

Run inside devenv environment:

```bash
devenv shell "bundle init"
```

### 3. Add Rails to Gemfile

Edit the `Gemfile` to either:
- Uncomment the rails gem if it exists as a comment, OR
- Add `gem "rails"` to the file

### 4. Fix Gemfile Permissions

```bash
chmod 644 Gemfile
```

### 5. Install Dependencies

```bash
devenv shell "bundle install"
```

### 6. Generate Rails Application

```bash
devenv shell "bundle exec rails new . --force"
```

Note: The `--force` flag overwrites existing files.

### 7. Restore .ruby-version

The Rails generator may overwrite `.ruby-version`. Revert it to its original content:

```bash
git checkout .ruby-version
```

### 8. Restore Devenv Ignore Entries

The Rails generator may remove devenv entries from `.gitignore` and `.dockerignore`. Check the diff and restore the following entries at the end of both files:

```
# Devenv
/.direnv
/.envrc
.devenv*
devenv.local.nix
```

### 9. Replace Capybara with Cuprite

Edit the `Gemfile` to replace the capybara gem with cuprite and launchy:

```ruby
gem "cuprite"
gem "launchy"
```

Then run bundle install again:

```bash
devenv shell "bundle install"
```

### 10. Configure System Tests

Edit `test/application_system_test_case.rb` to replace the default `driven_by` configuration with Cuprite. Add the content from `assets/languages/rails/application_system_test_case_additions.rb`:

```ruby
Capybara.test_id = "data-qa"
Capybara.add_selector(:test_id) do
  xpath do |locator|
    XPath.descendant[XPath.attr(Capybara.test_id) == locator]
  end
end

driven_by :cuprite, using: :chrome, screen_size: [ 1400, 1400 ], options: {
  headless: true,
  process_timeout: 20
}
```

Replace the existing `driven_by` line with this configuration.

### 11. Add Test Helpers

#### test/test_helper.rb

Add the following helpers inside the `ActiveSupport::TestCase` class. Read the content from `assets/languages/rails/test_helper_additions.rb`:

```ruby
def sop
  save_and_open_page
end

def sos
  save_and_open_screenshot
end
```

Also add at the top of the file:

```ruby
require_relative "test_helpers/session_test_helper"
```

And inside the `ActiveSupport::TestCase` class:

```ruby
include SessionTestHelper
```

#### test/test_helpers/session_test_helper.rb

Create this file with content from `assets/languages/rails/session_test_helper.rb`.

### 12. Add NoticeI18n Concern

#### app/controllers/concerns/notice_i18n.rb

Create this file with content from `assets/languages/rails/notice_i18n.rb`.

#### config/locales/en.yml

Add the i18n entries from `assets/languages/rails/locales_additions.yml` under the `en:` key.

### 13. Add Application Helper Methods

#### app/helpers/application_helper.rb

Add the helper methods from `assets/languages/rails/application_helper_additions.rb` inside the `ApplicationHelper` module:

- `form_errors` - renders form error partial
- `flash_message` - renders flash messages with proper styling
- `current_git_branch` - returns current git branch in development

### 14. Add View Templates

#### app/views/application/_flash_messages.html.erb

Create this file with content from `assets/languages/rails/views/_flash_messages.html.erb`.

#### app/views/application/_form_errors.html.erb

Create this file with content from `assets/languages/rails/views/_form_errors.html.erb`.

#### app/views/layouts/application.html.erb

Add flash messages at the top of `<body>` (content from `assets/languages/rails/views/layout_flash_messages.html.erb`):

```erb
<div id="flash-messages">
  <%= render "application/flash_messages" %>
</div>
```

Add branch indicator at the bottom of `<body>`, before the closing `</body>` tag (content from `assets/languages/rails/views/layout_branch_indicator.html.erb`):

```erb
<% if Rails.env.development? %>
  <div class="branch-indicator">
    <%= current_git_branch || "unknown" %>
  </div>
<% end %>
```

#### app/assets/stylesheets/branch-indicator.css

Create this file with content from `assets/languages/rails/stylesheets/branch-indicator.css`.

### 15. Copy Claude Rules

Copy the rules files from `assets/languages/rails/rules/` to the project's `.claude/rules/` directory:

```bash
mkdir -p .claude/rules
```

Copy:
- `assets/languages/rails/rules/rails.md` → `.claude/rules/rails.md`
- `assets/languages/rails/rules/rscss.md` → `.claude/rules/rscss.md`

### 16. Commit Changes

Add all files and commit:

```bash
git add .
git commit -m "Set up Rails application with devenv"
```

## Template Files Reference

All template files are located in `assets/languages/rails/`:

- `test_helper_additions.rb` - sop/sos helper methods
- `session_test_helper.rb` - SessionTestHelper module for authentication in tests
- `application_system_test_case_additions.rb` - Cuprite configuration for system tests
- `application_helper_additions.rb` - ApplicationHelper methods (form_errors, flash_message, current_git_branch)
- `notice_i18n.rb` - NoticeI18n concern for controller flash messages
- `locales_additions.yml` - I18n entries for the NoticeI18n concern
- `views/_flash_messages.html.erb` - Flash messages partial
- `views/_form_errors.html.erb` - Form errors partial
- `views/layout_flash_messages.html.erb` - Flash messages for layout (top of body)
- `views/layout_branch_indicator.html.erb` - Git branch indicator for layout (bottom of body, dev only)
- `stylesheets/branch-indicator.css` - Styling for the branch indicator
- `rules/rails.md` - Rails conventions for Claude
- `rules/rscss.md` - CSS conventions for Claude
