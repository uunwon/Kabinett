//
//  CalendarView.swift
//  Kabinett
//
//  Created by uunwon on 8/21/24.
//

import SwiftUI

struct CalendarView: View {
    @Binding var showCalendarView: Bool
    @Binding var startDateFiltering: Bool
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    @State private var selectedStartDate = Date()
    @State private var selectedEndDate = Date()
    
    @State private var showGraphicalStartCalendar = false
    @State private var showGraphicalEndCalendar = false

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            showCalendarView = false
                        }
                    } label: {
                        Text("취소")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.contentPrimary)
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            startDate = selectedStartDate
                            endDate = selectedEndDate
                            showCalendarView = false
                            startDateFiltering = true
                        }
                    } label: {
                        Text("확인")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(.contentPrimary)
                    }
                }
                .padding(.top, 15)
                .padding(.horizontal, 20)
                
                HStack {
                    Text("시작")
                        .foregroundStyle(.contentPrimary)
                    
                    Spacer()
                    
                    Text("\(formattedDate(date: selectedStartDate))")
                        .padding(.horizontal, 15)
                        .padding(.vertical, 6)
                        .background(.primary600.opacity(0.1))
                        .cornerRadius(7)
                        .onTapGesture {
                            withAnimation {
                                showGraphicalStartCalendar.toggle()
                                
                                if showGraphicalEndCalendar {
                                    showGraphicalEndCalendar.toggle()
                                }
                            }
                        }
                }
                .padding(.top, 10)
                .padding(.horizontal, 20)

                if showGraphicalStartCalendar {
                    Divider()
                        .padding(.leading, 20)
                    
                    DatePicker("시작", selection: Binding(get: { self.selectedStartDate }, set: { newValue in
                        self.selectedStartDate = newValue
                        self.validateStartDate()
                    }), in: ...Date(), displayedComponents: [.date])
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding(.top, -10)
                        .tint(.contentPrimary)
                }
                
                Divider()
                    .padding(.leading, 20)

                HStack {
                    Text("종료")
                        .foregroundStyle(.contentPrimary)
                    
                    Spacer()
                    
                    Text("\(formattedDate(date: selectedEndDate))")
                        .padding(.horizontal, 15)
                        .padding(.vertical, 6)
                        .background(.primary600.opacity(0.1))
                        .cornerRadius(7)
                        .onTapGesture {
                            withAnimation {
                                showGraphicalEndCalendar.toggle()
                                
                                if showGraphicalStartCalendar {
                                    showGraphicalStartCalendar.toggle()
                                }
                            }
                        }
                }
                .padding(.bottom, showGraphicalEndCalendar ? 0 : 10)
                .padding(.horizontal, 20)

                if showGraphicalEndCalendar {
                    Divider()
                        .padding(.leading, 20)
                    
                    DatePicker("종료", selection: Binding(get: { self.selectedEndDate }, set: { newValue in
                        self.selectedEndDate = newValue
                        self.validateEndDate()
                    }), in: ...Date(), displayedComponents: [.date])
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding(.top, -10)
                        .padding(.bottom, 15)
                        .tint(.black)
                }
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            
            Spacer()
        }
        .onAppear {
            if startDateFiltering {
                selectedStartDate = startDate
                selectedEndDate = endDate
            } else {
                selectedStartDate = Date()
                selectedEndDate = Date()
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd."
        return formatter.string(from: date)
    }
    
    private func validateStartDate() {
        if selectedStartDate > selectedEndDate {
            selectedEndDate = selectedStartDate
        }
    }
    
    private func validateEndDate() {
        if selectedEndDate < selectedStartDate {
            selectedStartDate = selectedEndDate
        }
    }
}


#Preview {
    CalendarView(
        showCalendarView: .constant(true),
        startDateFiltering: .constant(false),
        startDate: .constant(Date()),
        endDate: .constant(Date())
    )
}
