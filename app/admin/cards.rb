ActiveAdmin.register Card do
  permit_params :word, :translation, :example, :user_id
end
