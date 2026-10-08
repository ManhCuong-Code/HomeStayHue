using HomeStayHue.UseCases.SearchRoomScreen;
using HomeStayHue.UseCases.ViewRoomScreen;
using HomeStayHue.UseCases.BookingScreen;
using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using HomeStayHue.CoreBusiness.Models;
using HomeStayHue.CoreBusiness.Services;
using HomeStayHue.UseCases.PluginInterfaces.DataStore;
using HomeStayHue.UseCases.PluginInterfaces.UI;
using HomeStayHue.UseCases.PluginInterfaces.StateStore;
using HomeStayHue.UseCases.SearchProductScreen;
using HomeStayHue.UseCases.ViewProductSrceen;
using HomeStayHue.UseCases.ViewProductSrceen.Interfaces;
using HomeStayHue.UseCases.ShoppingCartScreen;
using HomeStayHue.UseCases.ShoppingCartScreen.Interfaces;
using HomeStayHue.UseCases.OrderConfirmationScreen;
using HomeStayHue.UseCases.AdminPortal.OutstandingOrdersScreen;
using HomeStayHue.UseCases.AdminPortal.ProcessedOrdersScreen;
using HomeStayHue.UseCases.AdminPortal.OrderDetailScreen;
using HomeStayHue.UseCases.AdminPortal.ProcessOrderScreen;
using HomeStayHue.ShoppingCart.LocalStorage;
using HomeStayHue.StateStore.DI;
using HomeStayHue.DataStore.SQL.Dapper;
using HomeStayHue.Web.Components;

var builder = WebApplication.CreateBuilder(args);

// 1. ADD BLAZOR INTERACTIVE SERVER
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents();

// 2. COOKIE AUTHENTICATION & AUTHORIZATION (PART 4)
builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.Cookie.Name = "HomeStayHue.Auth.Cookie";
        options.LoginPath = "/login";
        options.LogoutPath = "/logout";
        options.ExpireTimeSpan = TimeSpan.FromHours(8);
        options.SlidingExpiration = true;
    });

builder.Services.AddAuthorization();
builder.Services.AddCascadingAuthenticationState();

// 3. PLUGINS (PART 3 & PART 5)
// Plugin LocalStorage & StateStore (Part 3)
builder.Services.AddScoped<IShoppingCart, ShoppingCart>();
builder.Services.AddScoped<IShoppingCartStateStore, ShoppingCartStateStore>();

// Plugin SQL Dapper (Part 5)
builder.Services.AddSingleton<IDataAccess, DataAccess>();
builder.Services.AddScoped<IProductRepository, HomeStayHue.DataStore.SQL.Dapper.ProductRepository>();
builder.Services.AddScoped<IRoomRepository, HomeStayHue.DataStore.SQL.Dapper.ProductRepository>();
builder.Services.AddScoped<IOrderRepository, HomeStayHue.DataStore.SQL.Dapper.OrderRepository>();
builder.Services.AddScoped<IBookingRepository, HomeStayHue.DataStore.SQL.Dapper.OrderRepository>();

// 4. CORE SERVICES & USE CASES (PART 1, 2, 3, 4)
builder.Services.AddTransient<IOrderService, OrderService>();

// Customer Portal Use Cases (Part 1, 2, 3)
builder.Services.AddTransient<ISearchProductUseCase, SearchProductUseCase>();
builder.Services.AddTransient<IViewProductUseCase, ViewProductUseCase>();
builder.Services.AddTransient<IAddProductToCartUseCase, AddProductToCartUseCase>();
builder.Services.AddTransient<IViewShoppingCartUseCase, ViewShoppingCartUseCase>();
builder.Services.AddTransient<IDeleteProductUseCase, DeleteProductUseCase>();
builder.Services.AddTransient<IUpdateQuantityUseCase, UpdateQuantityUseCase>();
builder.Services.AddTransient<IPlaceOrderUseCase, PlaceOrderUseCase>();
builder.Services.AddTransient<IOrderConfirmationUseCase, OrderConfirmationUseCase>();
builder.Services.AddTransient<IBookingService, BookingService>();
builder.Services.AddTransient<ISearchRoomUseCase, SearchRoomUseCase>();
builder.Services.AddTransient<IViewRoomUseCase, ViewRoomUseCase>();
builder.Services.AddTransient<IPlaceBookingUseCase, PlaceBookingUseCase>();

// Admin Portal Use Cases (Part 4)
builder.Services.AddTransient<IViewOutstandingOrdersUseCase, ViewOutstandingOrdersUseCase>();
builder.Services.AddTransient<IViewProcessedOrdersUseCase, ViewProcessedOrdersUseCase>();
builder.Services.AddTransient<IViewOrderDetailUseCase, ViewOrderDetailUseCase>();
builder.Services.AddTransient<IProcessOrderUseCase, ProcessOrderUseCase>();

var app = builder.Build();

// 5. MIDDLEWARE PIPELINE
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error", createScopeForErrors: true);
    app.UseHsts();
}
app.UseStatusCodePagesWithReExecute("/not-found", createScopeForStatusCodePages: true);
app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();
app.UseAntiforgery();

app.MapStaticAssets();

// 6. MINIMAL API ENDPOINTS FOR AUTHENTICATION (PART 4)
// Xử lý Login truyền thống bằng HTTP POST để phát hành Cookie trình duyệt
app.MapPost("/authenticate", async (HttpContext context) =>
{
    var form = await context.Request.ReadFormAsync();
    string username = form["username"].ToString().Trim();
    string password = form["password"].ToString().Trim();

    // Xác thực tài khoản Admin mẫu: admin / 123456
    if (username.Equals("admin", StringComparison.OrdinalIgnoreCase) && password == "123456")
    {
        var claims = new List<Claim>
        {
            new Claim(ClaimTypes.Name, username),
            new Claim(ClaimTypes.Role, "Administrator"),
            new Claim("Department", "Management")
        };

        var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
        var principal = new ClaimsPrincipal(claimsIdentity);

        await context.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, principal, new AuthenticationProperties
        {
            IsPersistent = true,
            ExpiresUtc = DateTimeOffset.UtcNow.AddHours(8)
        });

        context.Response.Redirect("/admin");
        return;
    }

    context.Response.Redirect("/login?error=invalid");
});

// Xử lý Logout
app.MapGet("/logout", async (HttpContext context) =>
{
    await context.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
    context.Response.Redirect("/");
});

// 7. MAP RAZOR COMPONENTS WITH ALL MODULES
app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode()
    .AddAdditionalAssemblies(
        typeof(HomeStayHue.Web.CustomerPortal.Pages.SearchComponent).Assembly,
        typeof(HomeStayHue.Web.AdminPortal.Controls.OutstandingOrdersComponent).Assembly);

app.Run();
