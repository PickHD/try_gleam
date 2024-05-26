import gleam/dict
import gleam/io
import gleam/string

// Custom types
pub type Season {
  Spring
  Summer
  Autumn
  Winter
}

// Records (like struct/ object in another prog. lang)
pub type User {
  User(name: String, email: String)
}

// Generic Custom Types
pub type Option(inner) {
  Some(inner)
  None
}

// example constant
pub const my_name: Option(String) = Some("Taufik")

pub const my_age: Option(Int) = Some(22)

pub type Customer {
  Customer(name: String, age: Int, balance: Int)
}

pub type Movie {
  Movie(title: String, is_available: Bool, price: Int)
}

pub type EnterCinemaError {
  MovieNotAvailable
  NotEnoughMoney(required: Int)
  UnderAge
}

pub fn main() {
  // define variable
  let operator = "*"
  let first_number = 2
  let second_number = 3

  // case expression (switch)
  let result = case operator {
    "+" -> add(first_number, second_number)
    "-" -> substract(first_number, second_number)
    "*" -> multiply(first_number, second_number)
    "/" -> divide(first_number, second_number)
    _ -> -1
  }

  io.debug(result)

  // list are immutable (single linked list, good for add or remove from front)
  let fruit_baskets = ["apple", "grape"]

  io.debug(["watermelon", ..fruit_baskets])

  // list books still unchanged
  io.debug(fruit_baskets)

  // Call a function with another function
  io.debug(twice(3, 2, multiply))

  // Functions can be assigned to variables
  let func_add = add
  io.debug(func_add(1, 1))

  // Function anonymous
  let add_one = fn(x) { x + 1 }
  let exclaim = fn(x) { x <> "!" }

  io.debug(twice_generic(10, add_one))
  io.debug(twice_generic("Hi", exclaim))

  // Pipelines (up to bottom code)
  "Hello, Taufik!"
  |> string.drop_left(1)
  // ello, Taufik!
  |> string.drop_right(5)
  // ello, Ta
  |> io.debug

  io.debug(factorial(4))

  // tuple (come in handy when want to combine multiple values of different types)
  let biography = #("Taufik", 22, True)

  // destructuring tuple
  let #(name, age, is_alive) = biography

  // also can access using index 0,1,2 etc.
  io.debug(biography.0)

  io.debug(name)
  io.debug(age)
  io.debug(is_alive)

  io.debug(weather(Summer))

  // example create records
  let first_user = User(name: "Taufik", email: "taufikjanuar35@gmail.com")
  // example access field in records (record accessor)
  io.debug(first_user.email)

  // example update records (record are immutable, so first_user original record data does not mutate)
  let second_user = User(..first_user, email: "taufikjanuar22@gmail.com")
  io.debug(second_user.email)
  io.debug(my_name)
  io.debug(my_age)

  let first_customer_eligible =
    Customer(name: "Taufik Januar", age: 22, balance: 150_000)
  // let second_customer_not_eligible =
  //   Customer(name: "Kifuat Raunaj", age: 12, balance: 0)
  // let third_customer_eligible_but_no_money =
  //   Customer(name: "Surman", age: 32, balance: 0)

  let movie_gintama =
    Movie(title: "Gintama Movie Final", is_available: True, price: 37_500)

  let result = enter_cinema(first_customer_eligible, movie_gintama)
  io.debug(result)

  let animals = dict.from_list([#("Cat", "Meow"), #("Frog", "WOK WOK")])

  io.debug(animals)

  let animals =
    animals
    |> dict.insert("Dog", "Woof")
    |> dict.delete("Frog")

  io.debug(animals)
}

// functions
pub fn add(first_number: Int, second_number: Int) -> Int {
  first_number + second_number
}

pub fn substract(first_number: Int, second_number: Int) -> Int {
  first_number - second_number
}

/// Call a function to multiply based on two parameter given.
///
pub fn multiply(first_number: Int, second_number: Int) -> Int {
  first_number * second_number
}

pub fn divide(first_number: Int, second_number: Int) -> Int {
  first_number / second_number
}

// function as parameter
pub fn twice(
  args_first: Int,
  args_second: Int,
  passed_func: fn(Int, Int) -> Int,
) -> Int {
  passed_func(
    passed_func(args_first, args_second),
    passed_func(args_first, args_second),
  )
}

// function generic
pub fn twice_generic(argument: value, passed_func: fn(value) -> value) -> value {
  passed_func(passed_func(argument))
}

/// Call a function to do recursive over parameter given
///
pub fn factorial(x: Int) -> Int {
  case x {
    // Base case
    0 -> 1
    1 -> 1

    // Recursive case
    _ -> x * factorial(x - 1)
  }
}

// example pattern matching custom type using case expression
fn weather(season: Season) -> String {
  case season {
    Spring -> "Mild"
    Summer -> "Hot"
    Autumn -> "Windy"
    Winter -> "Cold"
  }
}

/// Call a function to do entering cinema based on customer & movie parameter given
///
pub fn enter_cinema(
  cust: Customer,
  movie: Movie,
) -> Result(String, EnterCinemaError) {
  case cust.age <= 17 {
    True -> Error(UnderAge)
    False ->
      case !movie.is_available {
        True -> Error(MovieNotAvailable)
        False ->
          case cust.balance < movie.price {
            True -> Error(NotEnoughMoney(movie.price))
            False -> {
              Ok("Enjoy the Show " <> cust.name <> "!")
            }
          }
      }
  }
}
