using HomeStayHue.CoreBusiness.Models;

namespace HomeStayHue.UseCases.ShoppingCartScreen.Interfaces
{
    public interface IViewShoppingCartUseCase
    {
        Task<Order> Execute();
    }
}