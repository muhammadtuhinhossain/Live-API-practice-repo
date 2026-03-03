class Urls{
  static String baseUrl='https://todo-restapi-crud-render.onrender.com';
  static String readProduct='$baseUrl/get_all_todo';
  static String deleteProduct(String id)=>'$baseUrl/delete_todo_by_id/$id';
  static String createProduct='$baseUrl/create_todo';
  static String updateProduct(String id)=>'$baseUrl/update_todo_by_id/$id';
}