using HomeStayHue.CoreBusiness.Models;

namespace HomeStayHue.UseCases.ShoppingCartScreen.Interfaces
{
    public interface IPlaceOrderUseCase
    {
        Task<string?> Execute(Order order);
    }
}