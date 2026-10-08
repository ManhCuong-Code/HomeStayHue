using HomeStayHue.CoreBusiness.Models;
using System.Threading.Tasks;

namespace HomeStayHue.UseCases.BookingScreen
{
    public interface IPlaceBookingUseCase
    {
        Task<string> Execute(Order order);
    }
}
