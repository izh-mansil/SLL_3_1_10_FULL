﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ТекущийКонтейнер; // ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера
Перем ТекущийСериализатор;
Перем ТекущиеСсылки; // Массив из ЛюбаяСсылка

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Инициализировать.
// 
// Параметры:
//  Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера
//  Сериализатор - СериализаторXDTO
Процедура Инициализировать(Контейнер, Сериализатор) Экспорт
	
	ТекущийКонтейнер = Контейнер;
	ТекущийСериализатор = Сериализатор;
	
	ТекущиеСсылки = Новый Массив();
	
КонецПроцедуры

Процедура ПересоздатьСсылкуПриЗагрузке(Знач Ссылка) Экспорт
	
	ТекущиеСсылки.Добавить(Ссылка);
	
	Если ТекущиеСсылки.Количество() > ЛимитСсылокВФайле() Тогда
		ЗаписатьПересоздаваемыеСсылки();
	КонецЕсли;
	
КонецПроцедуры

Процедура Закрыть() Экспорт
	
	ЗаписатьПересоздаваемыеСсылки();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЛимитСсылокВФайле()
	
	Возврат 34000;
	
КонецФункции

Процедура ЗаписатьПересоздаваемыеСсылки()
	
	Если ТекущиеСсылки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ИмяФайла = ТекущийКонтейнер.СоздатьФайл(ВыгрузкаЗагрузкаДанныхСлужебный.ReferenceRebuilding());
	ВыгрузкаЗагрузкаДанных.ЗаписатьОбъектВФайл(ТекущиеСсылки, ИмяФайла, ТекущийСериализатор);
	
	ТекущиеСсылки.Очистить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
