import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

/**
 * An organized display of facets and filters.
 *
 * @fires SearchFilter#facetvalueupdate
 */
export default class SearchFilter extends LightningElement {
    /**
     * An event fired when the user checks/unchecks a filter item.
     *
     * Properties:
     *   - Bubbles: true
     *   - Composed: true
     *
     * @event SearchLayout#showdetail
     * @type {CustomEvent}
     *
     * @property {ConnectApi.DistinctValueRefinementInput} refinements
     *   The unique identifier of the product.
     *
     * @export
     */

    /**
     * Gets or sets the display data for filters.
     *
     * @type {ConnectApi.DistinctValueSearchFacet[]}
     * @private
     */
    @api
    get displayData() {
        return this._displayData;
    }
    set displayData(value) {
        this._displayData = value;
        this.facets = value || [];
    }

    @api
    clearAll() {
        this._refinementMap.clear();
        this._facets = [];
        this._mruFacet = undefined;
    }

    @api
    setFilter(patternInFilterKey, patternFromFilterValue) {
        console.log(patternInFilterKey, patternFromFilterValue);

        if(patternFromFilterValue != 'Undefined'){
            let filter = this.template.querySelector('lightning-input[data-facet-id="' + patternInFilterKey + '"][data-filter-id="' + patternFromFilterValue + '"]');

            filter.checked = true;
         
            this._sections = [patternInFilterKey];
            
            console.log('facets: ', this.facets);
      

            this.facets[this.facets.length-1].carSelector = true;
            this.facets = JSON.parse(JSON.stringify(this.facets));

            console.log('facets: ', this.facets);
            
    
            setTimeout(filter.dispatchEvent(new Event('change')), 1000);            
        }


        else {
            console.log('je prazdny');

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Info',
                    message: 'There are no data for this car.',
                    variant: 'warning',
                    mode: 'dismissable'
                })
            );
        }
    }


    /**
     * Gets or sets the normalized facets for display.
     *
     * @private
     */
    get facets() {
        return this._facets || [];
    }
    set facets(value) {
        this._facets = value
            .map((facet) => this.mergeFacetIfMatch(this._mruFacet, facet))
            .map((facet) => ({
                ...facet,
                values: facet.values.map((val) => ({
                    ...val,
                    displayLabel: `${val.displayName} (${val.productCount})`
                })),
                foldable: facet.values.length > 5,
                folded: facet.carSelector === true ? false : true

            }));

        if (this._facets.length === 0 && this._mruFacet) {
            this._facets = [this._mruFacet];
        }

    }

    /**
     * Gets the active sections to show those as expanded in accordion.
     *
     * @type {string[]}
     */
    get activeSections() {
        return this._sections
            ? this._sections
            : (this.facets || []).map((facet) => facet.id);
    }

    /**
     * Merge the most recently used facet with the facet that received from
     * the search resutls. This is required since the API would only return
     * the selected filters (the refinements) when we supply the refinements
     * along with the search.
     * @param {*} mruFacet
     * @param {*} facet
     */
    mergeFacetIfMatch(mruFacet, facet) {
        let resultFacet;
        if (mruFacet && mruFacet.id === facet.id) {
            const mruValues = (mruFacet || {}).values || [];
            const facetValues = (facet || {}).values || [];

            const mergedMap = [...mruValues, ...facetValues].reduce(
                (map, value) => {
                    map.set(value.nameOrId, { ...value });
                    return map;
                },
                new Map()
            );

            resultFacet = {
                ...facet,
                values: Array.from(mergedMap.values())
            };
        } else {
            resultFacet = { ...facet };
        }

        return resultFacet;
    }

    /**
     * Emits a notification that the user checks/unchecks a filter item.
     *
     * @fires Filter#facetvalueupdate
     * @private
     */
    handleCheckboxChange(evt) {
        const facets = this.facets;
        const { filterId, facetId } = evt.target.dataset;
        const [currentFacet] = facets.filter((item) => item.id === facetId);

        if (this._refinementMap.has(facetId)) {
            const values = this._refinementMap.get(facetId);
            if (evt.detail.checked) {
                values.add(filterId);
            } else {
                values.delete(filterId);
            }
        } else {
            this._refinementMap.set(facetId, new Set([filterId]));
        }

        this._mruFacet = currentFacet;

        const refinements = facets.map(
            ({ id, attributeType, nameOrId, type }) => ({
                nameOrId,
                type,
                attributeType,
                values: this._refinementMap.has(id)
                    ? Array.from(this._refinementMap.get(id))
                    : []
            })
        );

        this.dispatchEvent(
            new CustomEvent('facetvalueupdate', {
                bubbles: true,
                composed: true,
                detail: { refinements }
            })
        );
    }

    handleShowMore(event) {
        let index = event.currentTarget.dataset.index;

        this.facets[index].folded = false;
    }

    handleShowLess(event) {
        let index = event.currentTarget.dataset.index;

        console.log('clicked index', index);
        this.facets[index].folded = true;
    }

    handleSectionToggle(event) {
        this._sections = event.detail.openSections;
    }

    _displayData;
    @track _facets = [];
    _mruFacet;
    _refinementMap = new Map();
    _sections;
}