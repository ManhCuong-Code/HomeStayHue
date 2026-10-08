using HomeStayHue.UseCases.PluginInterfaces.StateStore;
using HomeStayHue.UseCases.PluginInterfaces.DataStore;
using HomeStayHue.UseCases.PluginInterfaces.UI;
using HomeStayHue.UseCases.ViewProductSrceen.Interfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace HomeStayHue.UseCases.ViewProductSrceen
{
    public class AddProductToCartUseCase : IAddProductToCartUseCase
    {
        private readonly IProductRepository productRepository;
        private readonly IShoppingCart shoppingCart;
        private readonly IShoppingCartStateStore shoppingCartStateStore;

        public AddProductToCartUseCase(
            IProductRepository productRepository, 
            IShoppingCart shoppingCart,
            IShoppingCartStateStore shoppingCartStateStore)
        {
            this.productRepository = productRepository;
            this.shoppingCart = shoppingCart;
            this.shoppingCartStateStore = shoppingCartStateStore;
        }

        public async void Execute(int productId)
        {
            var product = productRepository.GetProduct(productId);
            if (product != null)
            {
                await shoppingCart.AddProductAsync(product);
                this.shoppingCartStateStore.UpdateLineItemsCount();
            }
        }
    }
}
