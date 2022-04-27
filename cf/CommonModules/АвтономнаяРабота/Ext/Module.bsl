﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработчик события формы ПриЧтенииНаСервере, который
// встраивается в формы элементов данных
// (элементов справочников, документов, записей регистров, и др.),
// чтобы заблокировать форму, если это попытка изменения неразделенных данных,
// получаемых из приложения, в автономном рабочем месте.
//
// Параметры:
//  ТекущийОбъект       - СправочникОбъект
//                      - ДокументОбъект
//                      - ПланВидовХарактеристикОбъект
//                      - ПланСчетовОбъект
//                      - ПланВидовРасчетаОбъект
//                      - БизнесПроцессОбъект
//                      - ЗадачаОбъект
//                      - ПланОбменаОбъект
//                      - РегистрСведенийМенеджерЗаписи - менеджер записи.
//  ТолькоПросмотр - Булево - свойство ТолькоПросмотр формы.
//
Процедура ОбъектПриЧтенииНаСервере(ТекущийОбъект, ТолькоПросмотр) Экспорт
	
	Если Не ТолькоПросмотр Тогда
		
		ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(ТекущийОбъект));
		АвтономнаяРаботаСлужебный.ОпределитьВозможностьИзмененияДанных(ОбъектМетаданных, ТолькоПросмотр);
		
	КонецЕсли;
	
КонецПроцедуры

// Отключает автоматическую синхронизацию между приложением в интернете
// и автономным рабочим местом в случаях когда, не задан пароль для установки подключения.
//
// Параметры:
//  Источник - РегистрСведенийНаборЗаписей.НастройкиТранспортаОбменаДанными - запись регистра настроек транспорта,
//             которая была изменена.
//
Процедура ОтключитьАвтоматическуюСинхронизациюДанныхСПриложениемВИнтернете(Источник) Экспорт
	
	АвтономнаяРаботаСлужебный.ОтключитьАвтоматическуюСинхронизациюДанныхСПриложениемВИнтернете(Источник);
	
КонецПроцедуры

// Читает и устанавливает настройку предупреждения о продолжительной синхронизации АРМ.
//
// Параметры:
//   ЗначениеФлага     - Булево - устанавливаемое значение флага
//   ОписаниеНастройки - Структура - принимает значение для описания настройки.
//
// Возвращаемое значение:
//   Булево, Неопределено - значение настройки отображения предупреждения о долгой синхронизации.
//
Функция ФлагНастройкиВопросаОДолгойСинхронизации(ЗначениеФлага = Неопределено, ОписаниеНастройки = Неопределено) Экспорт
	
	Возврат АвтономнаяРаботаСлужебный.ФлагНастройкиВопросаОДолгойСинхронизации(ЗначениеФлага, ОписаниеНастройки);
	
КонецФункции

// Возвращает адрес для восстановления пароля учетной записи приложения в интернете.
//
// Возвращаемое значение:
//   Строка - адрес восстановления пароля учетной записи.
//
Функция АдресДляВосстановленияПароляУчетнойЗаписи() Экспорт
	
	Возврат АвтономнаяРаботаСлужебный.АдресДляВосстановленияПароляУчетнойЗаписи();
	
КонецФункции

// Настраивает автономное рабочее место при первом запуске.
// Заполняет состав пользователей и другие настройки.
// Вызывается перед авторизацией пользователя. Может потребоваться перезапуск.
//
// Параметры:
//   Параметры - Структура - структура параметров.
//
// Возвращаемое значение:
//   Булево - признак возможности продолжения настройки автономного рабочего места.
//
Функция ПродолжитьНастройкуАвтономногоРабочегоМеста(Параметры) Экспорт
	
	Если Не АвтономнаяРаботаСлужебный.НеобходимоВыполнитьНастройкуАвтономногоРабочегоМестаПриПервомЗапуске() Тогда
		Возврат Ложь;
	КонецЕсли;
		
	Попытка
		АвтономнаяРаботаСлужебный.ВыполнитьНастройкуАвтономногоРабочегоМестаПриПервомЗапуске();
		Параметры.Вставить("ПерезапуститьПослеНастройкиАвтономногоРабочегоМеста");
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		
		ЗаписьЖурналаРегистрации(АвтономнаяРаботаСлужебный.СобытиеЖурналаРегистрацииСозданиеАвтономногоРабочегоМеста(),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		
		Параметры.Вставить("ОшибкаПриНастройкеАвтономногоРабочегоМеста",
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ИмяКонстантыАРМБазовойФункциональности() Экспорт
	
	Возврат "СтандартныеПодсистемыВАвтономномРежиме";
	
КонецФункции

Процедура ВыключитьСвойствоИБ() Экспорт
	
	ЭтоАвтономноеРабочееМесто = Константы.ЭтоАвтономноеРабочееМесто.СоздатьМенеджерЗначения();
	ЭтоАвтономноеРабочееМесто.Прочитать();
	Если ЭтоАвтономноеРабочееМесто.Значение Тогда
		
		ЭтоАвтономноеРабочееМесто.Значение = Ложь;
		МодульОбновлениеИнформационнойБазы = ОбщегоНазначения.ОбщийМодуль("ОбновлениеИнформационнойБазы");
		МодульОбновлениеИнформационнойБазы.ЗаписатьДанные(ЭтоАвтономноеРабочееМесто);
		
	КонецЕсли;
	
	ИмяКонстанты = ИмяКонстантыАРМБазовойФункциональности();
	Если Метаданные.Константы.Найти(ИмяКонстанты) <> Неопределено Тогда
		
		Если Константы[ИмяКонстанты].Получить() = Истина Тогда
			
			Константы[ИмяКонстанты].Установить(Ложь);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Для вызова из формы восстановления связи с главным узлом
// см. общую форму ВосстановлениеСвязиСГлавнымУзлом
//
Процедура ПриПодтвержденииОтключенияСвязиСГлавнымУзлом() Экспорт
	
	ИмяКонстанты = ИмяКонстантыАРМБазовойФункциональности();
	ЕстьКонстантаБазовойФункциональности = (Метаданные.Константы.Найти(ИмяКонстанты) <> Неопределено);
	
	Если Константы.ЭтоАвтономноеРабочееМесто.Получить() = Ложь
		И 
		(ЕстьКонстантаБазовойФункциональности 
			И Константы[ИмяКонстанты].Получить() = ЛОЖЬ) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ВыключитьСвойствоИБ();
	
	НеИспользоватьРазделениеПоОбластямДанных = Константы.НеИспользоватьРазделениеПоОбластямДанных.СоздатьМенеджерЗначения();
	НеИспользоватьРазделениеПоОбластямДанных.Прочитать();
	Если Не Константы.ИспользоватьРазделениеПоОбластямДанных.Получить()
		И Не НеИспользоватьРазделениеПоОбластямДанных.Значение Тогда
		
		НеИспользоватьРазделениеПоОбластямДанных.Значение = Истина;
		
		МодульОбновлениеИнформационнойБазы = ОбщегоНазначения.ОбщийМодуль("ОбновлениеИнформационнойБазы");
		МодульОбновлениеИнформационнойБазы.ЗаписатьДанные(НеИспользоватьРазделениеПоОбластямДанных);
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти