module Admin
  class CompaniesController < AdminController
    before_action :set_company, only: [:show, :edit, :update, :destroy]

    respond_to :html

    PER_PAGE = 20

    def index
      @companies = Company.all
    end

    def show
      render_modal('show', {:class=>'right'})
    end

    def new
      @company = Company.new
    end

    def edit
    end

    def create
      @company = Company.new(company_params)
      if @company.save
        flash[:notice] = "Company Created Successfully"
        redirect_to admin_companies_path
      else
        render 'new'
      end
    end

    def update
      if @company.update_attributes(company_params)
        flash[:notice] = "Company Updated Successfully"
        redirect_to admin_companies_path
      else
        render 'edit'
      end
    end

    def destroy
      @company.destroy
      respond_with(@company)
    end

    private
      def set_company
        @company = Company.find(params[:id])
      end

      def company_params
        params.require(:company).permit(
          :name,
          :logo,
          :favicon,
          :domain,
          :description,
          :from,
          :reply_to
        )
      end
  end
end
