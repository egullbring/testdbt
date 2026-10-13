# customer_project

dbt Core project for Azure Databricks using the `dbt-databricks` adapter.

## Local setup

1. Create and activate a Python virtual environment.
2. Install the adapter: `python -m pip install -r requirements.txt`.
3. Copy `profiles.yml.example` to `~/.dbt/profiles.yml` (create the `.dbt` directory if needed).
4. Set these environment variables in your shell before running dbt:

   - `DATABRICKS_HOST`: workspace URL, for example `https://adb-....azuredatabricks.net`
   - `DATABRICKS_HTTP_PATH`: HTTP Path for the SQL warehouse
   - `DATABRICKS_CATALOG`: Unity Catalog catalog name
   - `DATABRICKS_AZURE_TENANT_ID`: Microsoft Entra tenant ID
   - `DATABRICKS_AZURE_CLIENT_ID`: Azure service principal application/client ID
   - `DATABRICKS_AZURE_CLIENT_SECRET`: Azure service principal client secret
   - `DATABRICKS_SCHEMA` (optional): development schema; defaults to `dbt_dev`

Use a service principal with access to the SQL warehouse and the target catalog/schema. Do not commit credentials or a real `profiles.yml` file.

Then check the connection and run the project:

```sh
dbt debug
dbt build
```

## GitHub Actions

The workflow in `.github/workflows/dbt.yml` installs dbt, resolves packages, and parses the project on pushes and pull requests to `main`. When Databricks settings are configured, it also runs `dbt build` in a unique CI schema for that workflow run.

Add these repository Actions secrets in **Settings → Secrets and variables → Actions**:

- `DATABRICKS_HOST`
- `DATABRICKS_HTTP_PATH`
- `DATABRICKS_AZURE_TENANT_ID`
- `DATABRICKS_AZURE_CLIENT_ID`
- `DATABRICKS_AZURE_CLIENT_SECRET`

Add this Actions variable:

- `DATABRICKS_CATALOG`

For pull requests from forks, GitHub withholds repository secrets; those runs still install dependencies and parse the project, and skip the Databricks build. Configure the secrets and variable to enable warehouse builds.
