using HomeStayHue.CoreBusiness.Models;

namespace HomeStayHue.UseCases.PluginInterfaces.DataStore
{
    public interface IBookingRepository : IOrderRepository
    {
        Booking? GetBookingByCode(string bookingCode);
    }
}
