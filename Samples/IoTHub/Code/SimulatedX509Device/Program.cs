using System;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Azure.Devices.Client;
using System.Security.Cryptography.X509Certificates;

namespace SimulatedX509Device
{
    class Program
    {
        private static int MESSAGE_COUNT = 5;
        private const int TEMPERATURE_THRESHOLD = 30;
        private static String deviceId;
        private static StringBuilder iotHubName = new StringBuilder();
        private static String certPath;
        private static String certPW;
        private static float temperature;
        private static float humidity;
        private static Random rnd = new Random();
        
        static void Main(string[] args)
        {
            Console.Write("Enter device-id: ");
            deviceId = Console.ReadLine();
            Console.Write("Enter IoT Hub name: ");
            iotHubName.Append(Console.ReadLine());
            iotHubName.Append(".azure-devices.net");
            Console.Write("Enter path to device certificate (pfx file): ");
            certPath = Console.ReadLine();
            Console.Write("Enter X.509 Password: ");
            certPW = ReadPassword();
            Console.WriteLine();

            try
            {
                var cert = new X509Certificate2(certPath, certPW);
                var auth = new DeviceAuthenticationWithX509Certificate(deviceId, cert);
                var deviceClient = DeviceClient.Create(iotHubName.ToString(), auth, TransportType.Amqp_Tcp_Only);

                if (deviceClient == null)
                {
                    Console.WriteLine("Failed to create DeviceClient!");
                }
                else
                {
                    Console.WriteLine("Successfully created DeviceClient!");
                    SendEvent(deviceClient).Wait();
                }

                Console.WriteLine("Exiting...\n");
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error in sample: {0}", ex.Message);
            }
        }

        static string ReadPassword()
        {
            StringBuilder passWord = new StringBuilder();
            bool continueReading = true;
            const char newLineChar = '\r';

            while (continueReading)
            {
                ConsoleKeyInfo consoleKeyInfo = Console.ReadKey(true);
                char pwChar = consoleKeyInfo.KeyChar;

                if (pwChar == newLineChar)
                {
                    continueReading = false;
                }
                else
                {
                    passWord.Append(pwChar.ToString());
                }
            }
            return passWord.ToString();
        }

        static async Task SendEvent(DeviceClient deviceClient)
        {
            string dataBuffer;
            Console.WriteLine("Device sending {0} messages to IoTHub...\n", MESSAGE_COUNT);

            for (int count = 0; count < MESSAGE_COUNT; count++)
            {
                temperature = rnd.Next(20, 35);
                humidity = rnd.Next(60, 80);
                dataBuffer = string.Format("{{\"deviceId\":\"{0}\",\"messageId\":{1},\"temperature\":{2},\"humidity\":{3}}}", deviceId, count, temperature, humidity);
                Message eventMessage = new Message(Encoding.UTF8.GetBytes(dataBuffer));
                eventMessage.Properties.Add("temperatureAlert", (temperature > TEMPERATURE_THRESHOLD) ? "true" : "false");
                Console.WriteLine("\t{0}> Sending message: {1}, Data: [{2}]", DateTime.Now.ToLocalTime(), count, dataBuffer);

                await deviceClient.SendEventAsync(eventMessage);
            }
        }
    }
}
