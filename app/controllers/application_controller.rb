class ApplicationController < Sinatra::Base
    set :default_content_type, 'application/json'
    
    # Add your routes here

    ## Product Routes
    get "/products" do
        products = Product.all
        products.to_json(include: [:categories, :suppliers, :purchases])
    end

    get '/products/:id' do
        product = Product.find(params[:id])
        product.to_json(include: [:categories, :suppliers, :purchases])
    end

    post "/products" do
        new_product = Product.create({
            name: params[:name],
            inventory: params[:inventory],
            retail_price: params[:retail_price],
            image: params[:image]
        })

        new_collection = Collection.create({
            product_id: new_product.id,
            category_id: params[:category]
        }).to_json

        new_purchase = Purchase.create({
            product_id: new_product.id,
            supplier_id: params[:supplier]
        }).to_json

        new_product.to_json
    end

    patch '/products/:id' do
        product = Product.find(params[:id])
        product.update({
            name: params[:name],
            inventory: params[:inventory],
            retail_price: params[:retail_price],
            image: params[:image]
        })
        product.to_json
    end

    delete '/products/:id' do
        product = Product.find(params[:id])
        product.destroy
        product.to_json
    end

    ## Category Routes
    get '/categories' do 
        categories = Category.all
        categories.to_json( include: :products )
    end

    get '/categories/:id' do
        category = Category.find(params[:id])
        category.to_json( include: {products: {include: [:categories, :suppliers] }})
    end

    post '/categories' do
        category = Category.create({
            name: params[:name],
            description: params[:description]
        })
        category.to_json
    end

    patch '/categories/:id' do
        category = Category.find(params[:id])
        category.update({
            name: params[:name],
            description: params[:description]
        })
        category.to_json
    end

    delete '/categories/:id' do
        category = Category.find(params[:id])
        category.destroy
        category.to_json
    end

    ## Supplier Routes
    get '/suppliers' do
        suppliers = Supplier.all
        suppliers.to_json(include: :products)
    end

    get '/suppliers/:id' do
        supplier = Supplier.find(params[:id])
        supplier.to_json(include: {products: {include: [:suppliers, :categories]} })
    end

    post '/suppliers' do
        supplier = Supplier.create({
            name: params[:name],
            address: params[:address],
            phone: params[:phone]
        })
        supplier.to_json
    end

    patch '/suppliers/:id' do
        supplier = Supplier.find(params[:id])
        supplier.update({
            name: params[:name],
            address: params[:address],
            phone: params[:phone]
        })
        supplier.to_json
    end

    delete '/suppliers/:id' do
        supplier = Supplier.find(params[:id])
        supplier.destroy
        supplier.to_json
    end

    # Create collection (category and product)
    post '/collections' do
        new_collection = Collection.create({
            category_id: params[:category_id],
            product_id: params[:product_id]
        })
        new_collection.to_json
    end

    delete '/collections/:id' do
        collection = Collection.find(params[:id])
        collection.destroy
        collection.to_json
    end

    # Create collection (category and product)
    post '/suppliers' do
        new_supplier = Collection.create({
            supplier_id: params[:supplier_id],
            product_id: params[:product_id]
        })
        new_supplier.to_json
    end

    delete "/suppliers/:id" do 
        supplier = Supplier.find(params[:id])
        supplier.destroy
        supplier.to_json
    end

end