using HomeStayHue.CoreBusiness.Models;

namespace HomeStayHue.UseCases.ShoppingCartScreen.Interfaces
{
    public interface IUpdateQuantityUseCase
    {
        Task<Order> Execute(int productId, int quantity);
    }
}