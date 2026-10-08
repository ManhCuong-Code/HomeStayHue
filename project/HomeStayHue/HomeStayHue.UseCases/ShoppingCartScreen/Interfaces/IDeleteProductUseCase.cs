using HomeStayHue.CoreBusiness.Models;

namespace HomeStayHue.UseCases.ShoppingCartScreen.Interfaces
{
    public interface IDeleteProductUseCase
    {
        Task<Order> Execute(int productId);
    }
}