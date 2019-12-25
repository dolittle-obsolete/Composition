// Copyright (c) Dolittle. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using System.Threading.Tasks;
using Dolittle.Runtime.Server;

namespace Server
{
    /// <summary>
    /// Represents the entrypoint of the server.
    /// </summary>
    public static class Program
    {
        static async Task Main()
        {
            await Bootloader.Start().ConfigureAwait(false);
        }
    }
}
