project_name: "the_look"

local_dependency: {
  project: "constants"
}

constant: env {
  value: "{% if _user_attributes['env'] == 'dev' %}sam{% else %}null{% endif %}"
}
