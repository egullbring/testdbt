# customer_project

dbt Core project for Azure Databricks using the `dbt-databricks` adapter.

## Local setup

1. Create and activate a Python virtual environment.
2. Install the adapter: `python -m pip install -r requirements.txt`.
3. Copy `profiles.yml.example` to `~/.dbt/profiles.yml` (create the `.dbt` directory if needed).
4. Copy `databricks.env.example` to `databricks.env` and fill in your workspace URL, SQL warehouse HTTP Path, Unity Catalog name, service principal client ID, and client secret. `DATABRICKS_SCHEMA` is optional and defaults to `dbt_dev`.
5. Load the file into your shell before running dbt:

   ```sh
   set -a
   source databricks.env
   set +a
   ```

Use a service principal with access to the SQL warehouse and the target catalog/schema. Do not commit credentials or a real `profiles.yml` file.

Then check the connection and run the project:

```sh
dbt debug
dbt build
```

## GitHub Actions

The workflow in `.github/workflows/dbt.yml` installs dbt, resolves packages, and parses the project on pushes and pull requests to `main`. When Databricks settings are configured, it also runs `dbt build` in a unique CI schema for that workflow run.

To set up all the GitHub Actions values from that same local file, authenticate GitHub CLI with access to this repository and run:

```sh
./scripts/sync-github-databricks-config.sh
```

The script sends the four credential values to GitHub Actions Secrets and the catalog name to Actions Variables. The local `databricks.env` file is ignored by Git; keep it private. You can also enter those values manually in **Settings → Secrets and variables → Actions**.

For pull requests from forks, GitHub withholds repository secrets; those runs still install dependencies and parse the project, and skip the Databricks build. Configure the secrets and variable to enable warehouse builds.
