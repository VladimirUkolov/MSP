﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьДополнительныеОтчетыИОбработки(Команда)
	ВыполнитьКомандуВФоне("ОбновитьДополнительныеОтчетыИОбработки", НСтр("ru = 'Обновление дополнительных отчетов и обработок'"));
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыполнитьКомандуВФоне(ИмяКоманды, СопровождающийТекст)
	ПараметрыКоманды = ДополнительныеОтчетыИОбработкиКлиент.ПараметрыВыполненияКомандыВФоне(Параметры.ДополнительнаяОбработкаСсылка);
	ПараметрыКоманды.СопровождающийТекст = СопровождающийТекст + "...";
	
	Обработчик = Новый ОписаниеОповещения("ПослеЗавершенияДлительнойОперации", ЭтотОбъект, СопровождающийТекст);
	Если ЗначениеЗаполнено(Параметры.ДополнительнаяОбработкаСсылка) Тогда // Обработка подключена.
		ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьКомандуВФоне(ИмяКоманды, ПараметрыКоманды, Обработчик);
	Иначе
		ПоказатьОповещениеПользователя(ПараметрыКоманды.СопровождающийТекст, , , БиблиотекаКартинок.ДлительнаяОперация48);
		Операция = ВыполнитьКомандуНапрямую(ИмяКоманды, ПараметрыКоманды);
		ВыполнитьОбработкуОповещения(Обработчик, Операция);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ВыполнитьКомандуНапрямую(ИмяКоманды, ПараметрыКоманды)
	Операция = Новый Структура("Статус, КраткоеПредставлениеОшибки, ПодробноеПредставлениеОшибки");
	Попытка
		ДополнительныеОтчетыИОбработки.ВыполнитьКомандуИзФормыВнешнегоОбъекта(
			ИмяКоманды,
			ПараметрыКоманды,
			ЭтотОбъект);
		Операция.Статус = "Выполнено";
	Исключение
		Операция.КраткоеПредставлениеОшибки   = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Операция.ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	Возврат Операция;
КонецФункции

&НаКлиенте
Процедура ПослеЗавершенияДлительнойОперации(Операция, СопровождающийТекст) Экспорт
	Если Операция.Статус = "Выполнено" Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Успешное завершение'"), , СопровождающийТекст, БиблиотекаКартинок.Успешно32);
	Иначе
		ПоказатьПредупреждение(, Операция.КраткоеПредставлениеОшибки);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
