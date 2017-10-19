defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [parse_args: 1, sort_into_ascending_order: 1]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "The 3 arguments are returned if provided" do
    assert parse_args(["foo", "bar", 6]) == {"foo", "bar", 6}
  end



  test "default count used if only project and user passed" do
    assert parse_args(["foo", "bar"]) == {"foo", "bar", 4}
  end

  test "sort issues in ascending order" do
    assert sort_into_ascending_order(
    [
      %{"created_at" => "b"}, %{"created_at" => "a"}
    ]) == [
      %{"created_at" => "a"}, %{"created_at" => "b"}
    ]
  end
end
