# Attribution playbook
This dbt project is a worked example to demonstrate how to model customer
attribution. The SQL in this project is compatible with BigQuery.

If you want to run this project yourself to play with it (assuming you have
dbt installed):
1. Clone this repo.
2. Create a profile named `playbook`, or update the `profile:` key in the
`dbt_project.yml` file to point to an existing profile ([docs](https://docs.getdbt.com/docs/configure-your-profile)).
3. Run `dbt deps`.
4. Run `dbt seed`.
5. Run `dbt run` -- if you are using a warehouse other than Snowflake, you may
find that you have to update some SQL to be compatible with your warehouse.
6. Run `dbt test`.

