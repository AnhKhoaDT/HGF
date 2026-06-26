import React from "react";

export default function Home() {
  return (
    <div className="min-h-screen bg-[#f4efe6] text-[#2f342e] font-sans flex flex-col justify-between selection:bg-[#5c7150] selection:text-white">
      {/* Navigation Header */}
      <header className="border-b border-[#ddd4c4] bg-[#fbf8f2] py-4 px-6 sm:px-12 flex justify-between items-center sticky top-0 z-50">
        <div className="flex items-center gap-3 font-extrabold text-xl tracking-tight">
          <span className="w-8 h-8 rounded-lg bg-[#5c7150] text-white flex items-center justify-center text-lg">
            🍃
          </span>
          <span>
            Trip<span className="text-[#5c7150]">Wise</span>
          </span>
        </div>
        <nav className="hidden sm:flex items-center gap-8 font-semibold text-sm text-[#6b7064]">
          <a href="#" className="hover:text-[#2f342e] transition-colors">Tính năng</a>
          <a href="#" className="hover:text-[#2f342e] transition-colors">Bộ sưu tập</a>
          <a href="#" className="hover:text-[#2f342e] transition-colors">Khám phá</a>
        </nav>
        <button className="bg-[#b56a4a] text-white font-bold text-sm py-2 px-5 rounded-full hover:bg-[#a35e40] active:translate-y-[1px] transition-all shadow-sm">
          Bắt đầu ngay
        </button>
      </header>

      {/* Hero Section */}
      <main className="flex-1 max-w-4xl mx-auto px-6 py-16 sm:py-24 text-center flex flex-col items-center justify-center gap-8">
        <div className="inline-flex items-center gap-2 bg-[#e7ecdf] text-[#45563c] px-4 py-1.5 rounded-full text-xs font-bold tracking-wide uppercase border border-[#5c7150]/20">
          <span>🍃</span> Trợ lý du lịch AI thế hệ mới
        </div>
        <h1 className="text-4xl sm:text-6xl font-black tracking-tight leading-[1.1] max-w-3xl">
          Lên lịch trình du lịch cá nhân hóa chỉ trong{" "}
          <span className="text-[#5c7150] underline decoration-[#b56a4a]/40 decoration-wavy underline-offset-8">
            vài giây
          </span>
        </h1>
        <p className="text-lg sm:text-xl text-[#6b7064] max-w-2xl leading-relaxed">
          Tối ưu hóa hành trình khám phá Việt Nam của bạn dựa trên sở thích, ngân sách và nhịp độ mong muốn. Để AI thông minh của TripWise lo trọn vẹn lộ trình của bạn.
        </p>

        <div className="flex flex-col sm:flex-row gap-4 mt-4 w-full sm:w-auto">
          <button className="bg-[#5c7150] text-white font-bold py-3.5 px-8 rounded-xl hover:bg-[#45563c] transition-colors shadow-md">
            Lập kế hoạch miễn phí
          </button>
          <button className="bg-[#fbf8f2] border border-[#ddd4c4] text-[#2f342e] font-bold py-3.5 px-8 rounded-xl hover:bg-[#ece4d6] transition-colors">
            Khám phá điểm đến
          </button>
        </div>

        {/* Feature Highlights */}
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-6 w-full mt-16 pt-16 border-t border-[#ddd4c4]">
          <div className="bg-[#fbf8f2] p-6 rounded-2xl border border-[#ddd4c4] text-left">
            <div className="text-2xl mb-3">🎯</div>
            <h3 className="font-bold text-lg mb-1">Cá nhân hóa tối đa</h3>
            <p className="text-sm text-[#6b7064]">Thiết kế riêng theo sở thích nghỉ dưỡng, phiêu lưu hay khám phá ẩm thực.</p>
          </div>
          <div className="bg-[#fbf8f2] p-6 rounded-2xl border border-[#ddd4c4] text-left">
            <div className="text-2xl mb-3">⚡</div>
            <h3 className="font-bold text-lg mb-1">Tạo lịch trình cực nhanh</h3>
            <p className="text-sm text-[#6b7064]">Chỉ với vài câu hỏi đơn giản, toàn bộ chuyến đi được sắp xếp logic nhất.</p>
          </div>
          <div className="bg-[#fbf8f2] p-6 rounded-2xl border border-[#ddd4c4] text-left">
            <div className="text-2xl mb-3">📍</div>
            <h3 className="font-bold text-lg mb-1">Bản đồ trực quan</h3>
            <p className="text-sm text-[#6b7064]">Kết nối địa điểm mượt mà giúp bạn tiết kiệm thời gian di chuyển.</p>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="border-t border-[#ddd4c4] py-8 text-center text-xs text-[#6b7064] bg-[#ece4d6]">
        <p>© 2026 TripWise. Bản quyền thuộc về đội ngũ phát triển.</p>
      </footer>
    </div>
  );
}

