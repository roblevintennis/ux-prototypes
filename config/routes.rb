Rails.application.routes.draw do
  root 'static_pages#index'
  get 'static_pages/multiple_notes'
  get 'static_pages/another_prototype'
  get 'static_pages/single_point_zoom'
end
