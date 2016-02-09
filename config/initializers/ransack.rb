module Ransack
  module Constants
    remove_const(:ASC_ARROW) if (defined?(ASC_ARROW))
    remove_const(:DESC_ARROW) if (defined?(DESC_ARROW))

    ASC_ARROW = "<i class='fa fa-sort-up'></i>"
    DESC_ARROW = "<i class='fa fa-sort-down'></i>"
  end
end
