using HomeStayHue.CoreBusiness.Models;

namespace HomeStayHue.CoreBusiness.Services
{
    public interface IBookingService : IOrderService
    {
        bool ValidateBooking(Booking booking);
        bool ValidateOverbooking(int roomId, System.DateTime checkIn, System.DateTime checkOut);
    }
}
