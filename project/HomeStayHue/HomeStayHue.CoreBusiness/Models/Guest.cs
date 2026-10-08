using System;

namespace HomeStayHue.CoreBusiness.Models
{
    public class Guest
    {
        public int Id { get; set; }
        public string FullName { get; set; } = string.Empty;
        public string PhoneNumber { get; set; } = string.Empty;
        public string? Email { get; set; }
        public string? IdentityCard { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }

    public class RatePlan
    {
        public int Id { get; set; }
        public int RoomTypeId { get; set; }
        public DayOfWeek DayOfWeek { get; set; }
        public double Price { get; set; }
        public bool IsWeekend { get; set; }
        public double HolidaySurcharge { get; set; }
    }
}
