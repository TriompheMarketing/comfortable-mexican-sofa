class AddPublishedAtToComfyCmsPages < ActiveRecord::Migration[5.2]
  def change
    add_column :comfy_cms_pages, :published_at, :datetime
  end
end
