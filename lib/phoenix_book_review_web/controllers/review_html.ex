defmodule PhoenixBookReviewWeb.ReviewHTML do
  use PhoenixBookReviewWeb, :html

  embed_templates "review_html/*"

  def review_form(assigns) do
    ~H"""
    <.form :let={f} for={@changeset} action={@action}>
      <%= if @changeset.action do %>
        <div>Oops, something went wrong!</div>
      <% end %>
      
      <div>
        <label>Review Text</label>
        <textarea name={Phoenix.HTML.Form.input_name(f, :review_text)}><%= Phoenix.HTML.Form.input_value(f, :review_text) %></textarea>
      </div>
      
      <div>
        <label>Score (1-5)</label>
        <input type="number" min="1" max="5" name={Phoenix.HTML.Form.input_name(f, :score)} 
               value={Phoenix.HTML.Form.input_value(f, :score)} />
      </div>
      
      <div>
        <label>Upvotes</label>
        <input type="number" name={Phoenix.HTML.Form.input_name(f, :upvotes)} 
               value={Phoenix.HTML.Form.input_value(f, :upvotes)} />
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
        <input type="submit" value="Save Review" />
      </div>
    </.form>
    """
  end
end