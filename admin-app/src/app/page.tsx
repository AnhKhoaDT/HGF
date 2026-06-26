import React from "react";

export default function Home() {
  return (
    <div className="min-h-screen bg-[#f4efe6] text-[#2f342e] font-sans flex flex-col justify-between selection:bg-[#5c7150] selection:text-white">
      {/* Header */}
      <header className="border-b border-[#ddd4c4] bg-[#fbf8f2] py-4 px-6 sm:px-12 flex justify-between items-center sticky top-0 z-50">
        <div className="flex items-center gap-3 font-extrabold text-xl tracking-tight">
          <span className="w-8 h-8 rounded-lg bg-[#5c7150] text-white flex items-center justify-center text-lg">
            🍃
          </span>
          <span>
            TripWise <span className="text-[#b56a4a] text-xs font-bold px-2 py-0.5 rounded bg-[#f3e2d8] ml-1 uppercase tracking-wider">Admin</span>
          </span>
        </div>
        <div className="flex items-center gap-4">
          <span className="text-sm font-semibold text-[#6b7064]">Chào, Quản trị viên 👋</span>
          <div className="w-9 h-9 rounded-full bg-[#e0e8ea] border border-[#ddd4c4] flex items-center justify-center text-lg shadow-inner cursor-pointer">
            🧭
          </div>
        </div>
      </header>

      {/* Admin Shell */}
      <div className="flex-1 flex flex-col md:flex-row max-w-7xl w-full mx-auto p-4 sm:p-6 gap-6">
        {/* Sidebar */}
        <aside className="w-full md:w-64 flex-shrink-0 flex flex-col gap-2">
          <div className="bg-[#fbf8f2] border border-[#ddd4c4] rounded-2xl p-4 flex flex-col gap-1.5 shadow-sm">
            <div className="px-3 py-2 text-xs font-bold text-[#6b7064] uppercase tracking-wider">Hệ thống</div>
            <a href="#" className="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-bold bg-[#e7ecdf] text-[#45563c]">
              <span>✨</span> Tổng quan
            </a>
            <a href="#" className="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold text-[#6b7064] hover:bg-[#ece4d6] hover:text-[#2f342e] transition-colors">
              <span>📍</span> Địa điểm (POI)
            </a>
            <a href="#" className="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold text-[#6b7064] hover:bg-[#ece4d6] hover:text-[#2f342e] transition-colors">
              <span>🗂️</span> Quản lý lịch trình
            </a>
            <a href="#" className="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold text-[#6b7064] hover:bg-[#ece4d6] hover:text-[#2f342e] transition-colors">
              <span>👤</span> Người dùng
            </a>
            <a href="#" className="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold text-[#6b7064] hover:bg-[#ece4d6] hover:text-[#2f342e] transition-colors">
              <span>⚙️</span> Cấu hình AI
            </a>
          </div>

          <div className="bg-[#f3e9d2]/60 border border-[#ddd4c4] rounded-2xl p-4 text-xs text-[#6b7064] shadow-sm">
            <b className="text-[#c79a3f] block mb-1">💡 Mẹo nhỏ</b>
            Các thông số cấu hình AI sẽ tự động đồng bộ sau 5 phút chỉnh sửa hoặc khi bấm Lưu cấu hình.
          </div>
        </aside>

        {/* Dashboard Main Area */}
        <main className="flex-1 flex flex-col gap-6">
          {/* Stats Cards */}
          <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
            <div className="bg-[#fbf8f2] border border-[#ddd4c4] p-5 rounded-2xl shadow-sm">
              <div className="text-xs font-bold text-[#6b7064] uppercase mb-1">Người dùng mới</div>
              <div className="text-2xl font-black text-[#5c7150]">1,245</div>
              <div className="text-[11px] text-emerald-700 mt-1 font-semibold">↑ 12% so với hôm qua</div>
            </div>
            <div className="bg-[#fbf8f2] border border-[#ddd4c4] p-5 rounded-2xl shadow-sm">
              <div className="text-xs font-bold text-[#6b7064] uppercase mb-1">Lịch trình đã tạo</div>
              <div className="text-2xl font-black text-[#5c7150]">4,892</div>
              <div className="text-[11px] text-emerald-700 mt-1 font-semibold">↑ 8% tuần này</div>
            </div>
            <div className="bg-[#fbf8f2] border border-[#ddd4c4] p-5 rounded-2xl shadow-sm">
              <div className="text-xs font-bold text-[#6b7064] uppercase mb-1">Địa điểm (POI)</div>
              <div className="text-2xl font-black text-[#b56a4a]">824</div>
              <div className="text-[11px] text-[#6b7064] mt-1 font-semibold">Đã xác minh toàn bộ</div>
            </div>
            <div className="bg-[#fbf8f2] border border-[#ddd4c4] p-5 rounded-2xl shadow-sm">
              <div className="text-xs font-bold text-[#6b7064] uppercase mb-1">Tỷ lệ chính xác</div>
              <div className="text-2xl font-black text-[#5a7d8c]">98.6%</div>
              <div className="text-[11px] text-emerald-700 mt-1 font-semibold">Phản hồi tốt từ AI</div>
            </div>
          </div>

          {/* Activity Section */}
          <section className="bg-[#fbf8f2] border border-[#ddd4c4] rounded-2xl p-5 sm:p-6 shadow-sm flex flex-col gap-4">
            <div className="flex justify-between items-center pb-2 border-b border-[#ddd4c4]">
              <h2 className="font-bold text-lg">Yêu cầu lên lịch trình gần đây</h2>
              <button className="text-xs font-bold text-[#5c7150] hover:underline">Xem tất cả</button>
            </div>

            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse text-sm">
                <thead>
                  <tr className="border-b border-[#ddd4c4]/65 text-[#6b7064]">
                    <th className="pb-3 font-semibold">Thời gian</th>
                    <th className="pb-3 font-semibold">Điểm đến</th>
                    <th className="pb-3 font-semibold">Số ngày</th>
                    <th className="pb-3 font-semibold">Sở thích</th>
                    <th className="pb-3 font-semibold">Phương án AI</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-[#ddd4c4]/40 font-medium">
                  <tr>
                    <td className="py-3 text-xs text-[#6b7064]">Vừa xong</td>
                    <td className="py-3">🌲 Đà Lạt</td>
                    <td className="py-3">3 ngày</td>
                    <td className="py-3 flex gap-1">
                      <span className="text-[10px] bg-[#f3e9d2] text-[#c79a3f] px-2 py-0.5 rounded font-bold">Thư giãn</span>
                      <span className="text-[10px] bg-[#f3e2d8] text-[#b56a4a] px-2 py-0.5 rounded font-bold">Ẩm thực</span>
                    </td>
                    <td className="py-3 text-[#5c7150]">Cân bằng & trọn vẹn</td>
                  </tr>
                  <tr>
                    <td className="py-3 text-xs text-[#6b7064]">2 phút trước</td>
                    <td className="py-3">🏮 Hội An</td>
                    <td className="py-3">2 ngày</td>
                    <td className="py-3 flex gap-1">
                      <span className="text-[10px] bg-[#e7ecdf] text-[#45563c] px-2 py-0.5 rounded font-bold">Văn hóa</span>
                    </td>
                    <td className="py-3 text-[#5c7150]">Đậm chất văn hóa cổ</td>
                  </tr>
                  <tr>
                    <td className="py-3 text-xs text-[#6b7064]">5 phút trước</td>
                    <td className="py-3">🏖️ Nha Trang</td>
                    <td className="py-3">5 ngày</td>
                    <td className="py-3 flex gap-1">
                      <span className="text-[10px] bg-[#e0e8ea] text-[#5a7d8c] px-2 py-0.5 rounded font-bold">Biển</span>
                      <span className="text-[10px] bg-[#f3e2d8] text-[#b56a4a] px-2 py-0.5 rounded font-bold">Phiêu lưu</span>
                    </td>
                    <td className="py-3 text-[#5c7150]">Khám phá tối đa</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </section>
        </main>
      </div>

      {/* Footer */}
      <footer className="border-t border-[#ddd4c4] py-6 text-center text-xs text-[#6b7064] bg-[#ece4d6]">
        <p>© 2026 TripWise Admin. Hệ thống quản trị nội bộ.</p>
      </footer>
    </div>
  );
}

