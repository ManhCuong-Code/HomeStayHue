using HomeStayHue.CoreBusiness.Models;

namespace HomeStayHue.CoreBusiness.Services
{
    public class BookingService : OrderService, IBookingService
    {
        public bool ValidateBooking(Booking booking)
        {
            return ValidateCreateOrder(booking);
        }

        public bool ValidateOverbooking(int roomId, System.DateTime checkIn, System.DateTime checkOut)
        {
            return checkIn < checkOut;
        }
    }
}
