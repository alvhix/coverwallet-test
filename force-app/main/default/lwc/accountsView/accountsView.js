import { LightningElement, track, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getAccounts from "@salesforce/apex/AccountService.getAccounts";
import getNumberOfRecords from "@salesforce/apex/AccountService.getNumberOfRecords";
import ACCOUNTS_CONTACTS_CHANNEL from "@salesforce/messageChannel/Accounts_Contacts__c";
import { MessageContext, publish } from "lightning/messageService";

const COLUMNS = [
    { label: "Name", fieldName: "Name" },
    {
        label: "Annual Revenue",
        fieldName: "AnnualRevenue",
        type: "currency"
    },
    { label: "Number of Employees", fieldName: "NumberOfEmployees" },
    { label: "Priority", fieldName: "CustomerPriority__c" },
    { label: "Uuid", fieldName: "Uuid__c" }
];
const DELAY = 250;

export default class AccountsView extends LightningElement {
    @track data;
    @track searchTerm = "";
    @track recordsPerPage = "20";
    @track page = 1;
    @track totalPages = 1;
    @track accountsSelected = [];
    columns = COLUMNS;

    @wire(getAccounts, {
        name: "$searchTerm",
        recordsPerPage: "$recordsPerPage",
        page: "$page"
    })
    wiredAccounts({ error, data }) {
        if (data) {
            this.data = data;
        } else if (error) {
            this.data = undefined;
            this.showError("Error when extracting accounts", error);
            console.error(error);
        }
    }

    @wire(getNumberOfRecords, {
        name: "$searchTerm"
    })
    wiredTotalPages({ error, data }) {
        if (data) {
            this.totalPages = this.calculateTotalPages(data);
        } else if (error) {
            this.totalPages = undefined;
            this.showError("Error when extracting total pages", error);
        }
    }

    @wire(MessageContext)
    messageContext;

    // Search input
    handleKeyChange(event) {
        window.clearTimeout(this.delayTimeout);
        const searchTerm = event.target.value;
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(() => {
            this.searchTerm = searchTerm;
        }, DELAY);
        this.page = 1;
    }

    // Pagination
    calculateTotalPages(numberOfRecords) {
        return Math.ceil(numberOfRecords / parseInt(this.recordsPerPage, 10));
    }

    previousPage() {
        if (this.page > 1) {
            this.page--;
        }
    }

    nextPage() {
        if (this.page < this.totalPages) {
            this.page++;
        }
    }

    // Toast
    showError(title, message) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: "error"
        });
        this.dispatchEvent(evt);
    }

    // Accounts selected
    rowSelected() {
        this.accountsSelected.splice(0, this.accountsSelected.length);
        this.template
            .querySelector("lightning-datatable")
            .getSelectedRows()
            .forEach((element) => {
                this.accountsSelected.push(element.Id);
            });
        publish(
            this.messageContext,
            ACCOUNTS_CONTACTS_CHANNEL,
            this.accountsSelected
        );
    }

    // Entries per page
    changedRecordsPerPage(event) {
        this.recordsPerPage = event.detail.value;
        this.totalPages = this.calculateTotalPages(this.data.length);
        this.page = 1;
    }

    get options() {
        return [
            { label: "10", value: "10" },
            { label: "20", value: "20" },
            { label: "40", value: "40" }
        ];
    }
}
