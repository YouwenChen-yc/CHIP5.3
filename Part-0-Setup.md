# Part 0 - GitHub setup

As with our other CHIPS, you will be using a personal GitHub repository for this assignment.

### Copy Our Template Repository, Clone To Your Local Machine

As in previous CHIPS, you will need to first duplicate this repo's template to your personal GitHub account.Copy our
template repository to create a copy of our repo in your personal GitHub account, and not in any team areas!
Then, authenticate `git` with GitHub to clone the repository for this assignment. The clone instruction is no longer new 
to us, so we won't revisit those commands.

### Create A New Branch For Your Feature
It's a good habit to get into the practice of making a branch for changes you want to make, so you can later create a 
pull request before merging into `main` (which gives you the power to document your sets of commits thoroughly).

A good name for this branch would be something like `add-filtering`, which is descriptive of the feature you'll be 
adding in the next part of this assignment.

```bash
git checkout -b <BRANCH_NAME>
<make code changes to support the feature, then....>
git push -u origin <BRANCH_NAME>
```

You will now have a local branch to make edits that is connected to an identically named remote branch on the GitHub 
repo to which you should push frequently using the following commands:

```bash
git status # review your changes
git add [...] # you will need to include your own files!
git commit -m "your message here"
git push origin
```

### Docker Setup
You will also likely want to build and run your Docker container. Our repo comes with a Dockerfile again, so we'll do
the usual steps...
```bash
docker build -t hw-rails-intro .
docker run -it -v "$(pwd):/app" -p 3000:3000 hw-rails-intro
bundler install
rails server -p 3000 -b 0.0.0.0
```

### Bundler
Whenever you start working on a Rails project, the first thing you should do is to run Bundler, to make sure all the 
app's gems are installed. (We did this above when we fired up the Docker container.)

### Let's Migrate!
Finally, run the initial migration, which (since it's the very first migration) will also create the database itself:

```bash
bundle exec rails db:migrate
```

You can probably get away with just running `rails db:migrate` directly, but starting with your commands with 
`bundle exec` asks bundler to run the command in the context of the dependencies specified in the current app's 
`Gemfile` (rather than potentially pulling in a version of `rails` installed globally on the server you're using, 
which can cause dependency headaches down the line). It's a good habit to get into.

<details>
  <summary><strong>Self Check Question:</strong> How does Rails decide where and how to create the development database? (Hint: check the <code>db</code> and <code>config</code> subdirectories)</summary>
  <p><blockquote>The <code>rails db:migrate</code> command creates a local development database (following the specifications in <code>config/database.yml</code>) and runs the migrations in <code>db/migrate</code> to create the app's schema.  It also creates/updates the file <code>db/schema.rb</code> to reflect the latest database schema.  <strong>Note: it's important to keep this file under version control.</strong> </blockquote></p>
</details>
<br />

<details>
  <summary><strong>Self Check Question:</strong> What tables got created by the migrations?</summary>
  <p><blockquote>The <code>movies</code> table itself and the rails-internal <code>schema_migrations</code> table that records which migrations have been run. You can run <code>sqlite3 db/development.sqlite3</code> and then <code>.tables</code> to check all the tables in the database. (Press <code>Ctrl+D</code> to exit.)</blockquote></p>
</details>
<br />

Now insert "seed data" into the database. (_Seeds_ are initial data items that the app needs to run):

```sh
bundle exec rails db:seed
```

<details>
  <summary><strong>Self Check Question:</strong> What seed data was inserted and where was it specified? (Hint: <code>rake -T db:seed</code> explains the seed task; <code>rake -T</code> explains other available Rake tasks)</summary>
  <p><blockquote>A set of movie data which is specified in <code>db/seeds.rb</code></blockquote></p>
</details>
<br />

## Next
In this CHIP, as we did with others, we will need to deploy our application _somewhere_ in the cloud. Our two primary 
supported choices are linked below. You are welcome to use either, but recognize that the steps will vary, mostly due 
to the use of a database that is required for our application.
- [Part 0.A - Preparation To Deploy To Heroku](Part-0A-Preparation-To-Deploy-To-Heroku.md)
- [Part 0.B - Preparation To Deploy To Render](Part-0B-Preparation-To-Deploy-To-Render.md)