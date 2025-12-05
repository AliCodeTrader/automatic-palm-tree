// صفحه ثبت‌نام کاربر — فرم ساده و برای ساخت اکانت جدید
import 'package:flutter/material.dart';
// از متریال برای ساختن UI استفاده می‌کنیم

// خود صفحه Register به صورت Stateful چون وضعیت فرم و لودینگ عوض می‌شود
class RegisterScreen extends StatefulWidget {
  // سازنده‌ی ساده، فعلاً هیچ ورودی خاصی نمی‌گیرد
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

// استیت صفحه ثبت‌نام، اینجا منطق فرم را کنترل می‌کنیم
class _RegisterScreenState extends State<RegisterScreen> {
  // کلید فرم برای ولیدیشن (چک کردن درستی فیلدها)
  final _formKey = GlobalKey<FormState>();

  // کنترلر برای گرفتن شماره تلفن از کاربر
  final TextEditingController phoneController = TextEditingController();
  // کنترلر برای رمز عبور
  final TextEditingController passwordController = TextEditingController();
  // کنترلر برای تکرار رمز
  final TextEditingController confirmPasswordController = TextEditingController();

  // برای نشان دادن وضعیت در حال لود (دکمه غیر فعال و اسپینر)
  bool isLoading = false;
  // این برای مخفی/نمایش رمز اصلی است
  bool obscurePass = true;
  // این هم برای مخفی/نمایش تکرار رمز
  bool obscureConfirm = true;

  // متد build که UI صفحه ثبت‌نام را می‌سازد
  @override
  Widget build(BuildContext context) {
    // اسکفولد اصلی صفحه با AppBar و بدنه
    return Scaffold(
      appBar: AppBar(
        // عنوان بالای صفحه
        title: const Text("ثبت‌نام"),
        // وسط‌چین کردن عنوان
        centerTitle: true,
      ),
      // بدنه صفحه با کمی فاصله از لبه‌ها
      body: Padding(
        padding: const EdgeInsets.all(20),
        // فرم اصلی که روی آن ولیدیشن انجام می‌دهیم
        child: Form(
          key: _formKey,
          // همه‌ی فیلدها و دکمه‌ها را زیر هم در یک Column می‌چینیم
          child: Column(
            children: [
              // فیلد وارد کردن شماره تلفن
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "شماره تلفن",
                  hintText: "مثل 09123456789",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  // اگر کاربر چیزی ننوشته بود
                  if (value == null || value.isEmpty) return "شماره را وارد کن";
                  // اگر فرمت شماره تلفن با الگوی 09xxxxxxxxx یکی نبود
                  if (!RegExp(r"^09\d{9}$").hasMatch(value)) {
                    return "شماره معتبر نیست";
                  }
                  return null;
                },
              ),
              // فاصله بین فیلد شماره و فیلد رمز
              const SizedBox(height: 16),

              // فیلد وارد کردن رمز عبور
              TextFormField(
                controller: passwordController,
                obscureText: obscurePass,
                decoration: InputDecoration(
                  labelText: "رمز عبور",
                  border: const OutlineInputBorder(),
                  // آیکون چشم برای نشان دادن/مخفی کردن رمز
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePass ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      // وقتی روی آیکون می‌زنیم، وضعیت مخفی بودن رمز را برعکس می‌کنیم
                      setState(() => obscurePass = !obscurePass);
                    },
                  ),
                ),
                validator: (value) {
                  // اگر رمز خالی بود
                  if (value == null || value.isEmpty) return "رمز را وارد کن";
                  // رمز باید حداقل ۶ کاراکتر باشد
                  if (value.length < 6) return "حداقل ۶ کاراکتر";
                  return null;
                },
              ),
              // فاصله بین فیلد رمز و تکرار رمز
              const SizedBox(height: 16),

              // فیلد تکرار رمز عبور برای مطمئن شدن از درست نوشتن
              TextFormField(
                controller: confirmPasswordController,
                obscureText: obscureConfirm,
                decoration: InputDecoration(
                  labelText: "تکرار رمز عبور",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirm ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() => obscureConfirm = !obscureConfirm);
                    },
                  ),
                ),
                validator: (value) {
                  // اگر کاربر تکرار رمز را خالی گذاشت
                  if (value == null || value.isEmpty) return "تکرار رمز را وارد کن";
                  // اگر مقدار تکرار رمز با رمز اصلی یکی نباشد
                  if (value != passwordController.text) return "رمزها یکسان نیستند";
                  return null;
                },
              ),
              // فاصله قبل از دکمه ثبت‌نام
              const SizedBox(height: 24),

              SizedBox(
                // دکمه را تمام عرض صفحه می‌کنیم
                width: double.infinity,
                // ارتفاع دکمه
                height: 50,
                child: ElevatedButton(
                  // اگر در حال لود هستیم، دکمه غیر فعال می‌شود
                  onPressed: isLoading
                      ? null
                      : () {
                          // اگر همه فیلدها ولید بودند، ادامه می‌دهیم
                          if (_formKey.currentState!.validate()) {
                            // لودینگ را فعال می‌کنیم تا کاربر بفهمد در حال پردازش است
                            setState(() => isLoading = true);

                            // شبیه‌سازی یک تاخیر مثل درخواست به سرور (اینجا فیک است)
                            Future.delayed(const Duration(seconds: 2), () {
                              // بعد از تاخیر، لودینگ را خاموش می‌کنیم
                              setState(() => isLoading = false);

                              // یک پیغام ساده نشان می‌دهیم که ثبت‌نام موفق بوده
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("ثبت‌نام با موفقیت انجام شد"),
                                ),
                              );
                            });
                          }
                        },
                  child: 
                  // اگر در حال لود باشیم، اسپینر نشان می‌دهیم، وگرنه متن دکمه
                  isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("ساخت حساب"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
