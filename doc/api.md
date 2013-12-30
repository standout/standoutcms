# API

Standout CMS provides a simple API. Most operations are read-only.

## Formats

Currently, the API only responds with JSON and JSONP. ```application/json```
should be in your ```Accept``` header.

For JSONP, you will have to set the ```jsonp``` query parameter to your callback
name.

## Versioning

The current version is ```1```.

Every request should start with ```/v1```.

## Resources

The following resources are available through the API.

### CustomDataRows

* ```GET /custom_data_lists/:custom_data_list_id/custom_data_rows```
* ```GET /custom_data_lists/:custom_data_list_id/custom_data_rows/:id```

### ProductCategories

* ```GET /websites/:website_id/product_categories```
* ```GET /product_categories/:id```
* ```GET /product_categories/:id/parent```
* ```GET /product_categories/:id/children```

### Products

* ```GET /product_categories/:product_category_id/products```
* ```GET /products/:id```

### ProductVariants

* ```GET /products/:product_id/product_variants```
* ```GET /product_variants/:id```

### Carts

```Carts``` are accessible by a hard to guess API key. The reason for this is
that the ```Carts``` are mutable in the API. Only clients should know (or be
able to guess) the API key.

* ```POST /websites/:website_id/carts```
* ```GET  /carts/:api_key```
* ```PUT  /carts/:api_key```
* ```GET  /carts/:api_key/empty```

#### JSONP aliases

* ```GET /websites/:website_id/carts/create```
* ```GET /carts/:api_key/update```

### CartItems

```CartItems``` are accessible by a hard to guess API key. The reason for this
is that the ```CartItems``` are mutable in the API. Only clients should know (or be able to guess) the API key.

* ```GET    /carts/:api_key/cart_items```
* ```POST   /carts/:api_key/cart_items```
* ```PUT    /cart_items/:api_key```
* ```DELETE /cart_items/:api_key```

#### JSONP aliases

* ```GET /carts/:api_key/cart_items/create```
* ```GET /cart_items/:api_key/update```
* ```GET /cart_items/:api_key/destroy```

### Orders

Orders accept query parameters for three models; Order, Customer and Cart. This
is for saving XHRs on the client. This may change in the future.

Currently, orders only handle invoices through the API.

* ```POST /websites/:website_id/orders```

#### JSONP aliases

* ```GET /websites/:website_id/orders/create```

## Examples

Fetch all ```CustomDataRows``` for a given ```CustomDataList```.

```bash
curl api.standoutcms.se/v1/custom_data_lists/1/custom_data_rows
```

Fetch a ```CustomDataRow``` in a given ```CustomDataList``` and return as JSONP.

```bash
curl api.standoutcms.se/v1/custom_data_lists/1/custom_data_rows/1?jsonp=callback123
```
