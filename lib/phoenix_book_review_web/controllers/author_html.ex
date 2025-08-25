defmodule PhoenixBookReviewWeb.AuthorHTML do
  use PhoenixBookReviewWeb, :html

  embed_templates "author_html/*"

  def author_form(assigns) do
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
        <label>Date of birth</label>
        <input type="date" name={Phoenix.HTML.Form.input_name(f, :date_of_birth)} 
               value={Phoenix.HTML.Form.input_value(f, :date_of_birth)} />
      </div>
      
      <div>
        <label>Country of origin</label>
        <input type="text" name={Phoenix.HTML.Form.input_name(f, :country_of_origin)} 
               value={Phoenix.HTML.Form.input_value(f, :country_of_origin)} />
      </div>
      
      <div>
        <label>Description</label>
        <textarea name={Phoenix.HTML.Form.input_name(f, :description)}><%= Phoenix.HTML.Form.input_value(f, :description) %></textarea>
      </div>
      
      <div>
        <label>Profile Image</label>
        <input type="file" name="author[profile_image_upload]" accept="image/*" />
      </div>
      
      <div>
        <input type="submit" value="Save Author" />
      </div>
    </.form>
    """
  end
end