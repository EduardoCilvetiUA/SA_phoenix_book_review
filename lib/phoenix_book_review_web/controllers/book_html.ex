defmodule PhoenixBookReviewWeb.BookHTML do
  use PhoenixBookReviewWeb, :html

  embed_templates "book_html/*"

  def book_form(assigns) do
    ~H"""
    <.form :let={f} for={@changeset} action={@action} multipart={true}>
      <%= if @changeset.action do %>
        <div>Oops, something went wrong!</div>
      <% end %>
      
      <div>
        <label>Name</label>
        <input type="text" name={Phoenix.HTML.Form.input_name(f, :name)} 
               value={Phoenix.HTML.Form.input_value(f, :name)} />
      </div>
      
      <div>
        <label>Summary</label>
        <textarea name={Phoenix.HTML.Form.input_name(f, :summary)}><%= Phoenix.HTML.Form.input_value(f, :summary) %></textarea>
      </div>
      
      <div>
        <label>Publication Date</label>
        <input type="date" name={Phoenix.HTML.Form.input_name(f, :date_of_publication)} 
               value={Phoenix.HTML.Form.input_value(f, :date_of_publication)} />
      </div>
      
      <div>
        <label>Number of Sales</label>
        <input type="number" name={Phoenix.HTML.Form.input_name(f, :number_of_sales)} 
               value={Phoenix.HTML.Form.input_value(f, :number_of_sales)} />
      </div>
      
      <div>
        <label>Author</label>
        <select name={Phoenix.HTML.Form.input_name(f, :author_id)}>
          <%= for author <- @authors do %>
            <option value={author.id}><%= author.name %></option>
          <% end %>
        </select>
      </div>
      
      <div>
        <label>Cover Image</label>
        <input type="file" name="book[cover_image_upload]" accept="image/*" />
      </div>
      
      <div>
        <input type="submit" value="Save Book" />
      </div>
    </.form>
    """
  end
end