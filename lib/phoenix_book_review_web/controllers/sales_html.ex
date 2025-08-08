defmodule PhoenixBookReviewWeb.SalesHTML do
  use PhoenixBookReviewWeb, :html

  embed_templates "sales_html/*"

  def sales_form(assigns) do
    ~H"""
    <.form :let={f} for={@changeset} action={@action}>
      <%= if @changeset.action do %>
        <div>Oops, something went wrong!</div>
      <% end %>
      
      <div>
        <label>Year</label>
        <input type="number" name={Phoenix.HTML.Form.input_name(f, :year)} 
               value={Phoenix.HTML.Form.input_value(f, :year)} />
      </div>
      
      <div>
        <label>Sales Amount</label>
        <input type="number" name={Phoenix.HTML.Form.input_name(f, :sales_amount)} 
               value={Phoenix.HTML.Form.input_value(f, :sales_amount)} />
      </div>
      
      <div>
        <label>Book</label>
        <select name={Phoenix.HTML.Form.input_name(f, :book_id)}>
          <%= for book <- @books do %>
            <option value={book.id}><%= book.name %></option>
          <% end %>
        </select>
      </div>
      
      <div>
        <input type="submit" value="Save Sales" />
      </div>
    </.form>
    """
  end
end