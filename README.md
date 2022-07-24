# Marketing Attribution Modeling
This project aims to solve the attribution problem for Miro according to the given custom attribution rules. The SQL in this project is compatible with BigQuery.

In order to run this project, follow these steps (dbt must be installed):
1. Clone this repo.
2. Create a profile named `miro_assignment`, or update the `profile:` key in the
`dbt_project.yml` file to point to an existing profile ([docs](https://docs.getdbt.com/docs/configure-your-profile)). Make sure the `project` and `dataset` are set correctly in your `profile.yml` for BigQuery.
3. Run `dbt seed`.
4. Run `dbt run` .
5. Run `dbt test`.

The documentation about the algorithm can be found in the [docs](https://github.com/mowgliamu/attribution-modeling/blob/main/docs) direcotry and also [here](https://paper.dropbox.com/doc/Miro-Attribution-Documentation--Bl6b8UUno6DOCrwFqfL5LnbTAg-PdqPN2RVvtEhhSBYfoIkL) If you would like to generate automated documentation from dbt, run `dbt docs generate`.

