# LocalUtils for Rails Console

**LocalUtils** is a utility module designed to enhance your Rails console experience. It provides methods to measure execution time, analyze SQL queries, and more. This guide explains how to install and configure `LocalUtils` for your Rails environment.

## Installation

### 1. Clone the Repository

To get started with **LocalUtils**, clone the repository:

```bash
git clone https://github.com/alexrochas/railsc-utils.git
cd railsc-utils
```

### 2. Add `.irbrc` or `.pryrc` Configuration

To use **LocalUtils** in your Rails console, you'll need to configure either your `.irbrc` or `.pryrc` files. These modifications will make `LocalUtils` available each time you start the Rails console.

#### For `.irbrc` (Using IRB)

If you're using **IRB** for your Rails console, modify (or create) your `.irbrc` file located in your home directory (`~/.irbrc`):

```bash
nano ~/.irbrc
```

Add the following line to make `LocalUtils` available:

```ruby
if defined?(Rails::Console)
  puts 'Loading Custom Utils'
  # Load external utility file
  load '~/path/to/project/railsc-utils/lib/custom_utils.rb'

  extend LocalUtils
end
```

#### For `.pryrc` (Using Pry)

If you're using **Pry** as your Rails console, modify (or create) your `.pryrc` file located in your home directory (`~/.pryrc`):

```bash
nano ~/.pryrc
```

Add the following line to load `LocalUtils`:

```ruby
if defined?(Rails::Console)
  puts 'Loading Custom Utils'
  # Load external utility file
  load '~/path/to/project/railsc-utils/lib/local_utils.rb'

  extend LocalUtils
end
```

With these configurations, you’ll be able to call `LocalUtils` methods like `LocalUtils.measure` or `LocalUtils.explain` in your Rails console.

This ensures that **LocalUtils** is available every time you run your Rails console without needing to modify `.irbrc` or `.pryrc`.

---

## Main Functions

### 1. `LocalUtils.measure`

The `measure` function measures the execution time of any block of code, helping you understand how long different parts of your code take to run.

#### Usage:

```ruby
LocalUtils.measure do
  # Code to measure
  User.all
end
```

This will print the time taken for the block of code to execute.

### 2. `LocalUtils.explain`

The `explain` function analyzes the performance of ActiveRecord queries by running them with `EXPLAIN` and printing the execution plan. This shows how the database will execute the query.

#### Usage:

```ruby
LocalUtils.explain User.where(active: true).limit(1)
```

This will run the SQL `EXPLAIN` for the ActiveRecord query and display the execution plan.

### 3. `LocalUtils.pretty_print_sql`

The `pretty_print_sql` function formats and colorizes SQL queries executed by ActiveRecord, making the raw SQL easier to read in the Rails console.

#### Usage:

```ruby
LocalUtils.pretty_print_sql
```

After calling this, all subsequent SQL queries executed by ActiveRecord will be displayed in a formatted and colorized style.

---

## Contributing

If you have any ideas for additional features or improvements, feel free to contribute! Please fork the repository, make your changes, and submit a pull request.