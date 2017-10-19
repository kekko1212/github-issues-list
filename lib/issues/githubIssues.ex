defmodule Issues.GithubIssues do
  import Logger

  @github_url Application.get_env :issues, :github_url

  def fetch(user, project) do
    Logger.info("Fetching user #{user}'s project #{project }")
    issues_url(user, project)
    |> HTTPoison.get
    |> handle_response
  end

  defp issues_url(user, project) do
    url = "#{@github_url}/repos/#{user}/#{project}/issues"
    IO.puts "Getting issues from #{url}"
    url
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Logger.info("Successful response")
    Logger.debug fn() -> inspect body end
    {:ok, Poison.Parser.parse!(body)}
  end

  defp handle_response({_, %HTTPoison.Response{status_code: status, body: body}}) do
    Logger.error "Error #{status}"
    {:error, Poison.Parser.parse!(body)}
  end

  defp handle_response({_, %HTTPoison.Error{reason: reason}}) do
    {:error, Poison.Parser.parse!(reason)}
  end
end
