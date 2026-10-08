using System.Threading.Tasks;
using HomeStayHue.CoreBusiness.Models;
using HomeStayHue.UseCases.PluginInterfaces.DataStore;

namespace HomeStayHue.DataStore.SQL.Dapper
{
    public class UserRepository : IUserRepository
    {
        private readonly IDataAccess _dataAccess;

        public UserRepository(IDataAccess dataAccess)
        {
            _dataAccess = dataAccess;
        }

        public async Task<AppUser?> AuthenticateAsync(string username, string password)
        {
            const string sql = "SELECT * FROM dbo.AppUsers WHERE Username = @Username AND PasswordHash = @Password AND IsActive = 1";
            return await _dataAccess.QuerySingleAsync<AppUser, dynamic>(sql, new { Username = username, Password = password });
        }

        public async Task<AppUser?> GetByUsernameAsync(string username)
        {
            const string sql = "SELECT * FROM dbo.AppUsers WHERE Username = @Username AND IsActive = 1";
            return await _dataAccess.QuerySingleAsync<AppUser, dynamic>(sql, new { Username = username });
        }
    }
}
