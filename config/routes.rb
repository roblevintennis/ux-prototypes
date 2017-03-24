Rails.application.routes.draw do
  root 'static_pages#index'
  get 'static_pages/multiple_notes'
  get 'static_pages/multiple_notes2'
end
