project_name: "the_look"

constant: env {
  value: "{% if _user_attributes['env'] == 'dev' %}sam{% else %}null{% endif %}"
}
