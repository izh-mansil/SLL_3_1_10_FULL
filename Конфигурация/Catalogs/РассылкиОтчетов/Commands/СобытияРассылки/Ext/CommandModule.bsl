﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(Рассылка, Параметры)
	ПараметрыЖурналаРегистрации = ПараметрыЖурналаРегистрации(Рассылка);
	Если ПараметрыЖурналаРегистрации = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Рассылка еще не выполнялась.'"));
		Возврат;
	КонецЕсли;
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", ПараметрыЖурналаРегистрации, ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПараметрыЖурналаРегистрации(Рассылка)
	Возврат РассылкаОтчетов.ПараметрыЖурналаРегистрации(Рассылка);
КонецФункции

#КонецОбласти
