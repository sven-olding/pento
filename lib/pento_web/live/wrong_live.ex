defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    searched = get_random_number()
    IO.inspect(searched, label: "Searched number")

    {:ok,
     assign(socket,
       score: 0,
       message: "Make a guess",
       searched_number: searched,
       correct: false
     )}
  end

  defp get_random_number, do: :rand.uniform(10)

  def render(assigns) do
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: <%= @score %></h1>
    <h2><%= @message %></h2>
    <br />

    <h2 :if={!@correct}>
      <%= for n <- 1..10 do %>
        <.link
          class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border
          border-blue-700 rounded m-1"
          phx-click="guess"
          phx-value-number={n}
        >
          <%= n %>
        </.link>
      <% end %>
    </h2>
    <.link
      :if={@correct}
      class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 border-blue-700 rounded m-1"
      phx-click="restart"
    >
      Another try!
    </.link>
    <br />
    """
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    searched = socket.assigns.searched_number

    IO.inspect(guess, label: "Guess")
    {guessed_number, _} = Integer.parse(guess)
    correct = searched == guessed_number

    message =
      case correct do
        true -> "Your guess #{guess} was correct!"
        false -> "Your guess #{guess} was wrong!"
      end

    new_score =
      if correct, do: socket.assigns.score + 1, else: socket.assigns.score - 1

    {:noreply, assign(socket, message: message, score: new_score, correct: correct)}
  end

  def handle_event("restart", _unsigned_params, socket) do
    {:noreply,
     assign(socket,
       searched_number: get_random_number(),
       message: "Make a guess",
       correct: false
     )}
  end
end
